namespace :app do
  namespace :balance do
    desc "Calculate fight system balance values"
    task :fight_systems => :environment do
      characters = [
        [ 1,  1,  1,  0, 100],
        [ 2,  1,  3,  0, 100],
        [ 2,  3,  1,  0, 100],
        [ 3,  5,  5,  0, 100],
        [ 4, 10,  5,  0, 100],
        [ 4,  5, 10,  0, 100],
        [ 4,  5, 10, 20, 100],
        [ 4,  5, 10, 20, 150],
        [ 5,  5, 15, 20, 150],
        [ 5, 15,  5, 20, 150],
        [10, 45, 20, 20, 150],
        [10, 25, 40, 20, 150],
        [10, 65, 40, 20, 150],
        [10, 95, 40, 20, 150],
      ].collect{|level, attack_points, defence_points, fight_damage_reduce, health|
        OpenStruct.new(
          :title                => [level, attack_points, defence_points, fight_damage_reduce, health].join("_"),

          :level                => level,
          :attack_points        => attack_points,
          :defence_points       => defence_points,
          :fight_damage_reduce  => fight_damage_reduce,
          :health               => health
        )
      }

      fights = 1000

      [
        [:proportion,   FightingSystem::PlayerVsPlayer::Proportion],
        [:level_based,  FightingSystem::PlayerVsPlayer::LevelBased]
      ].each do |system_name, fight_system|
        attacker_wins = []
        average_attack = []
        average_defeat = []

        characters.each do |a, i|
          w = []
          attacks = []
          defences = []

          characters.each do |b, j|
            wins = 0
            attacker_damage = 0
            victim_damage = 0

            fights.times do
              won = fight_system.calculate(a, b)

              v_d, a_d = FightingSystem::DamageCalculation::Proportion.calculate(a, b, won)

              wins   += 1 if won
              attacker_damage += a_d
              victim_damage   += v_d
            end

            w << (wins.to_f / fights * 10000).round * 0.01
            attacks << (attacker_damage.to_f / fights * 100).round * 0.01
            defences << (victim_damage.to_f / fights * 100).round * 0.01

            print "."
            $stdout.flush
          end

          attacker_wins << w
          average_attack << attacks
          average_defeat << defences
        end

        [
          [:wins, attacker_wins],
          [:attack, average_attack],
          [:defeat, average_defeat]
        ].each do |file, values|
          File.open(Rails.root.join("tmp", "balance_#{system_name}_#{file}.csv"), "w+") do |f|
            f.puts(([""] + characters.collect(&:title)).join(";"))

            values.each_with_index do |set, index|
              f.puts(([characters[index].title] + set).join(";"))
            end
          end
        end

        puts
      end

      puts
      puts "Done!"
    end
  end
end
