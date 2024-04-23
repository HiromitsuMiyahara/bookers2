class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @users = User.all
    @user = User.find(current_user.id)
    @book = Book.new
  end

  # def create
  #   @book = Book.new
  #   @book.user_id = current_user.id
  #   @book.save
  #   redirect_to book_path(book.id)
  # end

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @user_id = current_user.id
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
    flash[:notice] = "You have updated user successfully."
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to book_path
    end
  end

end
