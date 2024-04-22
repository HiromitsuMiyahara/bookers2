class UsersController < ApplicationController

  def index
    @users = User.all
    @user = User.find(current_user.id)
  end

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books
    @user_id = current_user.id
  end

  def edit
    # user_id = current_user.id
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end


end
