class ProfilesController < ApplicationController
  before_filter :authenticate_admin!
  def new
    @profile = Profile.new
  end

  def create
  end

  def show
  end

  def index
    #@profiles = Profile.all
    @profiles = Profile.where("app_status = ?", true).paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.user.destroy
    @profile.destroy


    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :ok }
    end
  end

end
