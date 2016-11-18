class UsersMailer < ActionMailer::Base
  default  :from => "info@peershape.com"

  def forgot_password(user)
    @user = user
    mail(:to => @user.email, :subject=>"Reset your PeerShape password")
  end

  def reset_password(user,remote_ip)
    @user = user
    @remote_ip = remote_ip
    mail(:to => @user.email, :subject=>"Password reset confirmation from PeerShape")
  end

end
