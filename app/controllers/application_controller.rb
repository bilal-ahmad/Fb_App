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
      "http://stark-robot-3518.herokuapp.com/auth/facebook"
    elsif Rails.env.development?
      "http://localhost:3000/auth/facebook"
    end
  end

  def get_app_url
    if Rails.env.production?
      app_root_url = "http://apps.facebook.com/doyousocial"
    elsif Rails.env.development?
      app_root_url = "http://localhost:3000/"
    end
  end

end
