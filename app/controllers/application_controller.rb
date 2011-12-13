class ApplicationController < ActionController::Base
  protect_from_forgery

  def is_info_exist(omniauth, attr)
    if !omniauth['info'].blank? and !omniauth['info']["#{attr}"].blank?
      info = omniauth['info']["#{attr}"]
    elsif !omniauth['extra'].blank? and !omniauth['extra']['raw_info'].blank? and !omniauth['extra']['raw_info']["#{attr}"].blank?
      info = omniauth['extra']['raw_info']["#{attr}"]
    end
    info
  end

  def get_oauth_url
    if Rails.env.production?
      oauth_facebook_url = "http://stark-robot-3518.herokuapp.com/auth/facebook"
    elsif Rails.env.development?
      oauth_facebook_url = "http://localhost:3000/auth/facebook"
    end
    oauth_facebook_url
  end

  def get_root_url
    if Rails.env.production?
      facebook_url = "http://apps.facebook.com/260685093987581/"
    elsif Rails.env.development?
      facebook_url = "http://localhost:3000/"
    end
    oauth_facebook_url
  end

end
