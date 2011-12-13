class HomeController < ApplicationController

  def index
    if !current_user
      redirect_to get_oauth_url
    end
  end
end
