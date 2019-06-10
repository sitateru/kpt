class UserGroupsController < ApplicationController
  def show
    user = User.find(params[:user_id])
    render_ok(user.groups)
  end

  def update
    user = User.find(params[:user_id])
    if user.update(user_groups_params)
      render_ok(user.groups)
    else
      render_ng(400, user.errors)
    end
  end

  private

  def user_groups_params
    params.require(:user).permit(group_ids: [])
  end
end
