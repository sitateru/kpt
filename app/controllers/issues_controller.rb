class IssuesController < ApplicationController
  def index
    @r = Issue.ransack(params[:q]).result
    render_ok(JSON.parse(@r.includes(:users, :tags).to_json(include: [:users, :tags])))
  end

  def create
    issue = Issue.new(issue_params)
    if issue.save
      render_ok(issue)
    else
      render_ng(400, issue.errors)
    end
  end

  def update
    issue = Issue.find(params[:id])
    if issue.update(issue_params)
      render_ok(issue)
    else
      render_ng(400, issue.errors)
    end
  end

  def destroy
    issue = Issue.find(params[:id])
    issue.destroy
    render_ok(issue)
  end

  def open
    issue = Issue.find(params[:id])
    issue.is_closed = false
    if issue.save
      render_ok(issue)
    else
      render_ng(400, issue.errors)
    end
  end

  def close
    issue = Issue.find(params[:id])
    issue.is_closed = true
    if issue.save
      render_ok(issue)
    else
      render_ng(400, issue.errors)
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :body, :status)
  end
end
