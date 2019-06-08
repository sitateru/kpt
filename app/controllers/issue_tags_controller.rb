class IssueTagsController < ApplicationController
  def show
    issue = Issue.find(params[:issue_id])
    render_ok(issue.tags)
  end

  def update
    issue = Issue.find(params[:issue_id])
    if issue.update(issue_tags_params)
      render_ok(issue.tags)
    else
      render_ng(400, issue.errors)
    end
  end

  private

  def issue_tags_params
    params.require(:issue).permit(tag_ids: [])
  end
end
