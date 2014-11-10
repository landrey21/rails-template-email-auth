class UserMailer < ActionMailer::Base
  default from: "donotreply@landrey.net"

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to TemplateApp')
  end

  def reset_pw(user)

  end

  def change_email(user)

  end
end
