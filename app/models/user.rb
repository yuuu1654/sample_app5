class User < ApplicationRecord
  # => User.first
  # => User.all
  attr_accessor :remember_token
  before_save {self.email = self.email.downcase} 
  #自分自身か変数を定義しているのかわからないからemailにはselfつける
  validates :name,  presence: true, 
                      length: {maximum: 50}
                      
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, 
                      length: {maximum: 255}, 
                      format: {with: VALID_EMAIL_REGEX},
                  uniqueness: true
                  
  has_secure_password    
  
  validates :password, presence: true, 
                         length: {minimum: 6}, 
                      allow_nil: true
  
  #渡された文字列のハッシュ値を返す
  def User.digest(string) #三項演算子
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをDBに記憶する
  def remember #一つ目
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  #渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget #一つ目
    self.update_attribute(:remember_digest, nil)
  end
  
end
