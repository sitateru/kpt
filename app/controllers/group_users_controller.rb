class GroupUsersController < ApplicationController
  def show
    group = Group.find(params[:group_id])
    render_ok(group.users)
  end

  def update
    group = Group.find(params[:group_id])
    if group.update(group_users_params)
      render_ok(group.users)
    else
      render_ng(400, group.errors)
    end
  end

  def group_users_params
    params.require(:group).permit(user_ids: [])
  end
end
