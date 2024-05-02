class SearchesController < ApplicationController
  before_action :authenticate_user! #ログインしていないとログイン画面に戻す。

  def search
    @model =params[:model] #検索モデル→params[:model]
    @word =params[:word] #検索ワード→params[:word]

    if @model == "User" #検索モデルUser or Bookで条件分岐
      @users = User.looks(params[:search], params[:word])#検索方法 →params[:search]
    else
      @books = Book.looks(params[:search], params[:word])#検索方法 →params[:search]
    end
  end
end

#looksメソッドを使い、検索内容を取得し、変数に代入
#検索方法params[:search]と、検索ワードparams[:word]を参照してデータを検索
#1：インスタンス変数@usersにUserモデル内での検索結果を代入
#2：インスタンス変数@booksにBookモデル内での検索結果を代入
#インスタンス変数@wordに検索ワードを代入するため定義（検索結果の画面で使用）
