class UsersController < ApplicationController

  def index
    @users = User.all
    @user = User.find(current_user.id)
  end

  # def create
  #   book = Book.new
  #   book.user_id = current_user.id
  #   book.save
  #   redirect_to book_path(book.id)
  # end

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @user_id = current_user.id
    @books = @user.books
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
