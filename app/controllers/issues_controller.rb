class IssuesController < ApplicationController

  def index
    render_ok(Issue.all)
  end

  def create
    issue = Issue.new(issue_params)
    if issue.save
      render_ok(issue)
    else
      render_ng(400, issue.errors) 
    end
  end

  def destroy
    Issue.find(params[:id]).destroy
    render_ok(issue)
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :body, :status)
  end
end
