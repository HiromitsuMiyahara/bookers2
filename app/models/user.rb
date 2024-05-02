class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #relationshipsとreverse_of_relationshipsがあるが、わかりにくいため名前をつけているだけ。
  #class_name: "Relationship"でRelationshipテーブルを参照します。
  #foreign_key(外部キー)で参照するカラムを指定。

  # 一覧画面で使う
  #「has_many :テーブル名, through: :中間テーブル名」 の形を使って、テーブル同士が中間テーブルを
  #通じてつながっていることを表現します。(followerテーブルとfollowedテーブルのつながりを表す）
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #フォロー・フォロワーの一覧画面で、user.followersという記述でフォロワーを表示したいので、
  #throughでスルーするテーブル、sourceで参照するカラムを指定。

  # フォローしたときの処理
def follow(user_id)
  relationships.create(followed_id: user_id)
end
# フォローを外すときの処理
def unfollow(user_id)
  relationships.find_by(followed_id: user_id).destroy
end
# フォローしているか判定
def following?(user)
  followings.include?(user)
end

  has_one_attached :profile_image

  validates :name, presence: true
  validates :name, length: { in: 2..20 }
  validates :name, uniqueness: true
  validates :introduction,  length: { maximum: 50 }

  #検索実装
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  #・完全一致→perfect_match
  #・前方一致→forward_match
  #・後方一致→backword_match
  # ・部分一致→partial_match

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default-image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
