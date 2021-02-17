class AccountActivationsController < ApplicationController
  
  #!user.activated?という記述にご注目ください。
  #先ほど「１つ論理値を追加します」と言ったのはここで利用したいからです。
  #このコードは、既に有効になっているユーザーを誤って再度有効化しないために必要です。
  #正当であろうとなかろうと、有効化が行われるとユーザーはログイン状態になります。
  #もしこのコードがなければ、攻撃者がユーザーの有効化リンクを後から盗みだして
  #クリックするだけで、本当のユーザーとしてログインできてしまいます。
  #そうした攻撃を防ぐためにこのコードは非常に重要です。
  
  # GET /account_activations/:id/edit
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate #user.rbにリファクタリング
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  
end
