class AppController < ApplicationController

  def index
    authenticated?
  end
end
