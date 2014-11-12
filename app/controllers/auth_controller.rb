class AuthController < ApplicationController

  layout 'site'

  #--------------------------------------------------------
  def signin
    # renders signin form
    @user = User.new
  end

  #--------------------------------------------------------
  def signin_post

    reset_session
    email = params[:email].downcase
    @user = User.find_by email: email
    if @user == nil
      @user = User.new
      flash.now[:alert] = 'Incorrect email or password.'
    elsif !@user.deleted_at.nil?
      flash.now[:alert] = 'Inactive account.'
    elsif @user.failed_signins > 5
      flash.now[:alert] = 'This account has been locked due to excessive sign in attempts.'
    elsif !@user.authenticate(params[:password])
      flash.now[:alert] = 'Incorrect email or password.'
      @user.failed_signins += 1
      @user.save
    elsif @user.is_blocked
      flash.now[:alert] = 'This account has been blocked.'
    elsif @user.email_confirmation != '1'
      flash.now[:alert] = 'This email address must be confirmed before you can sign in.  Please check your email.'
    else
      session[:user_id] = @user.id
      session[:user_email] = params[:email]
      session[:user_name] = @user.name
      @user.failed_signins = 0
      @user.last_signin = Time.now.to_s(:db)
      @user.save
      redirect_to :app
      return
    end
    render 'signin'
  end

  #--------------------------------------------------------
  def signout
    reset_session
    redirect_to controller: 'home', action: 'index'
  end

  #--------------------------------------------------------
  def reset_pw
    # renders reset_pw form
    @user = User.new
  end

  #--------------------------------------------------------
  def reset_pw_post

    email = params[:email].downcase
    @user = User.find_by email: email
    if @user == nil
      @user = User.new
      flash.now[:alert] = 'Email address not found.'
    else
      charset = 'ACDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz2345679'
      password_str = (0...8).map{ charset[rand(charset.size)] }.join
      @user.encrypt_password(password_str)
      @user.failed_signins = 0
      if @user.save
        flash.now[:notice] = 'Your password has been reset.  Please check your email.'
        # send email with new password
        UserMailer.reset_pw(@user, password_str, request).deliver
      else
        flash.now[:alert] = @user.errors.full_messages.join('; ')
      end
    end
    render 'reset_pw'
  end

end
