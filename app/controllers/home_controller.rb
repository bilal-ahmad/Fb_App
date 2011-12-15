class HomeController < ApplicationController
  before_filter :register_user
  def index
    if !current_user and !current_admin
      redirect_to get_oauth_url
    #else
    #  redirect_to get_root_url
    end
  end

  def register_user
    redirect_to get_oauth_url if !current_user
  end
end
