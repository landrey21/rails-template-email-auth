class UserController < ApplicationController

  #---------------------------------------------------------
  def create 
    @user = User.new()
    render layout: 'site'
  end

  #---------------------------------------------------------
  def post

    @user = User.new()
    if (defined?(params[:email]))
      email = params[:email].downcase
      existing_user = User.find_by email: email
      unless existing_user.nil?
        flash.now[:alert] = 'Email already in use.'
      else
        #@user = User.new(params[:user].permit(:email, :name))
        @user.name = params[:name]
        @user.email = email
        @user.encrypt_password(params[:password])
        @user.email_confirmation_hash(email)
        if @user.save
          # TODO send welcome email
          render 'created', layout: 'site'
          return
        else
          flash.now[:alert] = @user.errors.full_messages.join('. ') 
        end
      end
    else
        flash.now[:alert] = 'Email is required.'
    end
    render 'create', layout: 'site'
  end

  #---------------------------------------------------------
  def edit
    authenticated?
    @user = User.find_by id: session[:user_id]
  end

  #---------------------------------------------------------
  def put
    authenticated?
    @user = User.find_by id: session[:user_id]
    @user.name = params[:name]
    if @user.save
      session[:user_name] = @user.name
      flash.now[:notice] = 'Your profile has been updated.'
    else
      flash.now[:alert] = @user.errors.full_messages.join('. ')
    end

    render 'edit'
  end

  #---------------------------------------------------------
  def change_pw
    authenticated?
    @user = User.find_by id: session[:user_id]
  end

  #---------------------------------------------------------
  def change_pw_post

    authenticated?
    @user = User.find_by id: session[:user_id]
    if (defined?(params[:new_password])) && @user.authenticate(params[:password])
      @user.encrypt_password(params[:new_password])
      if @user.save
        flash.now[:notice] = 'Your password has been updated.'
      else
        flash.now[:alert] = @user.errors.full_messages.join('. ')
      end
    else
      flash.now[:alert] = 'Invalid password.' 
    end

    render 'change_pw'
  end

  #---------------------------------------------------------
  def change_email
    authenticated?
    @user = User.find_by id: session[:user_id]
  end

  #---------------------------------------------------------
  def change_email_post
    authenticated?
    @user = User.find_by id: session[:user_id]
    if (defined?(params[:new_email])) && @user.authenticate(params[:password])
      new_email = params[:new_email].downcase
      existing_user = User.find_by email: new_email
      if existing_user == nil
        @user.email = new_email
        if @user.save
          session[:user_email] = @user.email
          flash.now[:notice] = 'Your email has been updated.'
          # TODO - send email notification
        else
          flash.now[:alert] = @user.errors.full_messages.join('. ')
        end
      else
        flash.now[:alert] = 'Email already in use.'
      end
    else    
      flash.now[:alert] = 'Invalid email or password.'
    end

    render 'change_email'
  end

  #---------------------------------------------------------
  def confirm_email
    if (defined?(params[:confirmation]))
      @user = User.find_by email_confirmation: params[:confirmation]
      if @user.nil?
        #@message = 'Confirmation code not found.'
        flash.now[:alert] = 'Confirmation code not found.'
      else
        @user.email_confirmation = 1
        unless @user.save
          flash.now[:alert] = @user.errors.full_messages.join('. ')
        end
      end
    else
      flash.now[:alert] = 'Confirmation code is required.'
    end

    render layout: 'site'
  end

end
