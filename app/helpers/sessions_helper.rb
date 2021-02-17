module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #ユーザーIDと記憶トークンはペアで扱う必要がある
  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # DB への問い合わせを可能な限り減らしたい
    if (user_id = session[:user_id]) #データベースの問い合わせ回数を減らす為のif
      @current_user ||= User.find_by(id: user_id) 
      # @currrent_user = @current_user || User.find
    elsif (user_id = cookies.signed[:user_id])
      #raise #testがパスすれば、この部分がテストされてないことが分かる
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user #メモ化
      end
    end
  end
  
  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  #testヘルパーのis_logged_in?メソッドと区別(testでも使える為)
  def logged_in?
    !current_user.nil? #nilじゃないですよね
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  #現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL(もしくはデフォルト値)にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
                              #paramsとかと同じ
  end
  
end
