class GroupsController < ApplicationController
  def index
    render_ok(JSON.parse(Group.all.includes(:users).to_json(include: :users)))
  end

  def show
    group = Group.find(params[:id])
    render_ok(JSON.parse(group.to_json(include: :users)))
  end

  def create
    group = Group.new(group_params)
    if group.save
      render_ok(JSON.parse(group.to_json(include: :users)))
    else
      render_ng(400, group.errors)
    end
  end

  def update
    group = Group.find(params[:id])
    if group.update(group_params)
      render_ok(JSON.parse(group.to_json(include: :users)))
    else
      render_ng(400, group.errors)
    end
  end

  def destroy
    group = Group.find(params[:id])
    if group.destroy
      render_ok(group)
    else
      render_ng(400, group.errors)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
