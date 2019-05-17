class UsersController < ApplicationController
  def index
    render_ok(JSON.parse(User.all.includes(:issues).to_json(include: :issues)))
  end

  def show
    user = User.find(params[:id])
    render_ok(JSON.parse(user.to_json(include: :issues)))
  end

  def create
    user = User.new(user_params)
    if user.save
      render_ok(user)
    else
      render_ng(400, user.errors)
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render_ok(user)
    else
      render_ng(400, user.errors)
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render_ok(user)
    else
      render_ng(400, user.errors)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
