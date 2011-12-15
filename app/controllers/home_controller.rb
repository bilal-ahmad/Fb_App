class HomeController < ApplicationController
  before_filter :register_user
  def index
  end

  def register_user
    redirect_to get_oauth_url if !current_user
  end
end
