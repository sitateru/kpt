class AssignmentsController < ApplicationController
  def index
    render_ok(JSON.parse(Assignment.includes(:user, :issue).to_json(include: [:user, :issue])))
  end

  def create
    assignment = Assignment.new(assignment_params)
    if assignment.save
      render_ok(assignment)
    else
      render_ng(400, assignment.errors)
    end
  end

  def destroy
    assignment = Assignment.find(params[:id])
    assignment.destroy
    render_ok(assignment)
  end

  private

  def assignment_params
    params.require(:assignment).permit(:issue_id, :user_id)
  end
end
