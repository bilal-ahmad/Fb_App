class HomeController < ApplicationController
  before_filter :register_user
  def index
    @auth_url = get_oauth_url if !current_user

  end

  def register_user
    redirect_to get_app_url if current_user
  end

end
