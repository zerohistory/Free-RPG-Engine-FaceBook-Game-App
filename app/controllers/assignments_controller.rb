class AssignmentsController < ApplicationController
  def new
    @assignment = parents.last.assignments.build(:role => params[:role])
    @relations = Setting.b(:assignment_mercenaries) ? current_character.relations : current_character.friend_relations

    render :new, :layout => "ajax"
  end

  def create
    @assignment = parents.last.assignments.build(params[:assignment])

    @assignment.save

    render :layout => 'ajax'
  end

  def destroy
    if params[:id] == 'all'
      current_character.assignments.clear
    else
      @assignment = Assignment.find(params[:id])

      if @assignment.context == current_character or @assignment.context.character == current_character
        @assignment.destroy
      end
    end

    render :layout => 'ajax'
  end
end
