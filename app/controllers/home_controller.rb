class HomeController < ApplicationController

  def index
    if !current_user
      redirect_to get_oauth_url
    else
      redirect_to get_root_url
    end
  end
end
