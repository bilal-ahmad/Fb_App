class SocialAppsController < ApplicationController
  before_filter :authenticate_admin!
  # GET /social_apps
  # GET /social_apps.json
  def index
    @social_apps = SocialApp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @social_apps }
    end
  end

  # GET /social_apps/1
  # GET /social_apps/1.json
  def show
    @social_app = SocialApp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @social_app }
    end
  end

  # GET /social_apps/new
  # GET /social_apps/new.json
  def new
    @social_app = SocialApp.new
    @social_app.build_setting

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @social_app }
    end
  end

  # GET /social_apps/1/edit
  def edit
    @social_app = SocialApp.find(params[:id])
  end

  # POST /social_apps
  # POST /social_apps.json
  def create

    params[:social_app][:user_id] = current_admin.id
    params[:social_app][:setting_attributes][:permissions] = set_permissions(params[:social_app][:setting_attributes])
    @social_app = SocialApp.new(params[:social_app])

    respond_to do |format|
      if @social_app.save
        format.html { redirect_to @social_app, notice: 'Social app was successfully created.' }
        format.json { render json: @social_app, status: :created, location: @social_app }
      else
        format.html { render action: "new" }
        format.json { render json: @social_app.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_permissions(permissions)
    set_user_permissions = Array.new
    ["publish_stream", "email", "offline_access", "manage_pages", "create_event", "rsvp_event", "xmpp_login"].each do |permission|
      if !permissions[permission].blank? and permissions[permission] == '1'
        set_user_permissions << permission
      end
    end
    permissions_str = set_user_permissions.join ','
  end
  # PUT /social_apps/1
  # PUT /social_apps/1.json
  def update
    @social_app = SocialApp.find(params[:id])
    params[:social_app][:setting_attributes][:permissions] = set_permissions(params[:social_app][:setting_attributes])

    respond_to do |format|
      if @social_app.update_attributes(params[:social_app])
        format.html { redirect_to @social_app, notice: 'Social app was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @social_app.errors, status: :unprocessable_entity }
      end
    end
  end

  def facebook_error
    @error = params[:error]
  end
  # DELETE /social_apps/1
  # DELETE /social_apps/1.json
  def destroy
    @social_app = SocialApp.find(params[:id])
    @social_app.destroy

    respond_to do |format|
      format.html { redirect_to social_apps_url }
      format.json { head :ok }
    end
  end


end
