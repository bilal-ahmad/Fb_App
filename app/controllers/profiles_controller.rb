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
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

end
