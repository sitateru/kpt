class UsersController < ApplicationController
  def index
    render_ok(User.all)
  end

  def show
    user = User.find(params[:id])
    render_ok(user)
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
    if user.update_attributes(user_params)
      render_ok(user)
    else
      render_ng(400, user.errors)
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render_ok(user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
