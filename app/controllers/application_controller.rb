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


end
