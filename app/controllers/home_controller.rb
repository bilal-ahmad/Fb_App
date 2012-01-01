class HomeController < ApplicationController
  def index
    if params[:user].present? and params[:user] == "cc"  or admin_signed_in?
      @video = Event.find_by_active(true)
      render :layout => "script_layout"
    else
      redirect_to validate_user_path
    end
  end

  def validate_user
    @auth_url = get_oauth_url
  end

end
