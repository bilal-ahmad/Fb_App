class HomeController < ApplicationController
  def index
    if !current_user
      @auth_url = get_oauth_url
    end
  end
end
