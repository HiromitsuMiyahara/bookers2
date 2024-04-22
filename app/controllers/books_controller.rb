class BooksController < ApplicationController
  def index
    @books = Book.all
    @user = User.find(current_user.id)
    
  end

  def create
    @book = Book.new
    @book.user_id = current_user.id
    @book.save
    redirect_to book_path(@book.id)
  end

  def show
    @book = Book.find(params[:id])
    @user = User.find(current_user.id)
  end

  def edit
  end
  
  def update
    
  end
  
  def destroy
    
  end

  # private

  # def book_params
  #   params.require(:book).permit(:title, :body)
  # end
end
