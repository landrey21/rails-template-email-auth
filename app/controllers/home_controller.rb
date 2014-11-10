class HomeController < ApplicationController

  layout 'site'

  def index
    if session[:user_id]
      redirect_to :app
    end
  end
end
