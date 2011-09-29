class MissionResult
  attr_reader :character, :mission, :level, :mission_group,
    :energy, :money, :experience, :boost,
    :level_rank, :mission_rank, :group_rank,
    :payouts

  def self.create(*args)
    new(*args).tap do |r|
      r.save!
    end
  end

  def initialize(character, mission)
    @character      = character
    @mission        = mission
    @mission_group  = mission.mission_group

    @level_rank   = character.mission_levels.rank_for(@mission)
    @level        = @level_rank.level
  end

  def save!
    if valid?
      MissionLevelRank.transaction do
        # Checking if energy assignment encountered free fulfillment
        if free_fulfillment?
          @energy = 0
        else
          if boost = @character.boosts.best_energy and boost.energy <= @level.energy
            @boost = boost
            
            @energy = (@level.energy - @boost.energy)

            @character.inventories.take!(@boost.item)
          else
            @energy = @level.energy
          end
        end

        @character.ep -= @energy

        payout_triggers = []

        if success?
          @experience = @level.experience
          @money      = (@level.money * (1 + @character.assignments.mission_income_effect * 0.01)).ceil

          @level_rank.progress += 1
          @level_rank.save!

          @character.experience += @experience

          @character.charge(- @money, 0, @mission)

          @character.missions_succeeded += 1

          if @level_rank.just_completed?
            @character.missions_completed += 1
            @character.missions_mastered  += 1 if @level.last?

            @character.points += 1

            @mission_rank = @character.missions.check_completion!(@mission)
            @group_rank = @character.mission_groups.check_completion!(@mission_group)

            @character.news.add(:mission_complete,
              :mission_id     => @mission.id,
              :level_rank_id  => @level_rank.id,
              :payouts        => @payouts
            )

            payout_triggers << :level_complete
            payout_triggers << :mission_complete if @mission_rank.completed?
            payout_triggers << :mission_group_complete if @group_rank.completed?
          else
            payout_triggers << (@level_rank.completed? ? :repeat_success : :success)
          end
        else
          payout_triggers << (@level_rank.completed? ? :repeat_failure : :failure)
        end

        @payouts = @level.applicable_payouts.apply(@character, payout_triggers, @mission)

        @character.save!
      end

      @saved = true
    end
  end

  def saved?
    @saved
  end

  def success?
    if @success.nil?
      @success = Dice.chance(@level.chance, 100)
    end

    @success
  end

  def new_record?
    !saved?
  end

  def enough_energy?
    @character.ep >= @level.energy
  end

  def free_fulfillment?
    if @free_fulfillment.nil?
      @free_fulfillment = Dice.chance(@character.assignments.mission_energy_effect, 100)
    end

    @free_fulfillment
  end

  def requirements_satisfied?
    if @requirements_satisfied.nil?
      @requirements_satisfied = @mission.requirements.satisfies?(@character)
    end

    @requirements_satisfied
  end

  def received_something?
    !(@money.nil? && @experience.nil? && @payouts.by_action(:add).empty?)
  end

  protected

  def valid?
    (mission.repeatable? || !@level_rank.completed?) and
    enough_energy? and
    requirements_satisfied?
  end
end
