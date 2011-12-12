class RegistrationsController < Devise::RegistrationsController
  before_filter :protect
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def protect
    redirect_to root_path
  end

  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end