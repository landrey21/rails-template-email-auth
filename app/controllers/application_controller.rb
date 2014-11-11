class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticated?
    unless session[:user_id]
      flash[:alert] = 'Your session has expired.  Please Sign In to continue.'
      redirect_to(:controller => 'auth', :action => 'signin')
      return false
    else
      return true
    end
  end

end
