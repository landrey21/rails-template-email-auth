class UserMailer < ActionMailer::Base
  default from: "donotreply@landrey.net"

  def welcome(user, request)
    @user = user
    @url = 'http://' + request.host + '/user/confirm_email/' + @user.email_confirmation
    @app_name = 'TemplateApp'
    mail(to: @user.email, subject: 'Welcome to ' + @app_name)
  end

  def reset_pw(user, password, request)
    @user = user
    @password = password
    @url = 'http://' + request.host + '/auth/signin'
    @app_name = 'TemplateApp'
    mail(to: @user.email, subject: @app_name + ' - Password Reset')
  end

  def change_email(user)

  end
end
