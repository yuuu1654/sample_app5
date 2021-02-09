module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザーを返す
  def current_user
    # DB への問い合わせを可能な限り減らしたい
    if session[:user_id] #データベースの問い合わせ回数を減らす為のif
      @current_user ||= User.find_by(id: session[:user_id]) #メモ化
      # @currrent_user = @current_user || User.find
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  #testヘルパーのis_logged_in?メソッドと区別(testでも使える為)
  def logged_in?
    !current_user.nil? #nilじゃないですよね
  end
  
  #現在のユーザーでログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
end
