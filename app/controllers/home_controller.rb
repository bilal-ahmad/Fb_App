class HomeController < ApplicationController
  def index
    if !current_user
      redirect_to validate_user_path
    end
  end

  def validate_user
    @auth_url = get_oauth_url
  end

end
