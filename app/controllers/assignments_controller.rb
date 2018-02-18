class AssignmentsController < ApplicationController
  def index
    render_ok(Assignment.find(params[:issue_id]))
  end

  private

  def assignment_params
    params.require(:assignment).permit(:issue_id, :user_id)
  end
end
