class BooksController < ApplicationController
  before_action :is_matching_login_book, only: [:edit, :update]

  def index
    @books = Book.all
    @user = current_user.id
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user.id
      render :index
    end
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = current_user
    @book_comment = BookComment.new
  end

  def edit
    # is_matching_login_book
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    flash[:notice] = "Book was successfully destroyed."
    redirect_to '/books'
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_book
    @book = current_user.books.find_by(id: params[:id])
    unless @book
      redirect_to books_path
    end
  end
end
