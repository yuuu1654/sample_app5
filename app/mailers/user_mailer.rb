class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user #インスタンス変数にするとテキストに読み出せる
    mail to: user.email, subject: "Account activation"
    # => return: mail object (text/html)
    #   example: mail.deliver
  end
  
  # @user.send_reset_email 
  # UserMailer.password_reset(self).deliver_now
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
