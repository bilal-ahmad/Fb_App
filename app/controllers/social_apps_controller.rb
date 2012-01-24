class SocialAppsController < ApplicationController
  before_filter :authenticate_admin!

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

    fb_application = get_application_info(params[:social_app][:setting_attributes][:facebook_id], params[:social_app][:setting_attributes][:facebook_secret])

    if fb_application
      params[:social_app][:setting_attributes][:permissions] = set_permissions(params[:social_app][:setting_attributes])
      params[:social_app][:name] = fb_application['name']
      params[:social_app][:setting_attributes][:callback_url] = "http://localhost:3000/auth/#{fb_application['name']}/create"
      params[:social_app][:setting_attributes][:icon_url] = fb_application['icon_url']
      params[:social_app][:setting_attributes][:canvas_name] = fb_application['canvas_name']
      params[:social_app][:setting_attributes][:link] = fb_application['link']
      params[:social_app][:setting_attributes][:logo_url] = fb_application['logo_url']
      params[:social_app][:setting_attributes][:namespace] = fb_application['namespace']
      params[:social_app][:setting_attributes][:contact_email] = fb_application['contact_email']
      params[:social_app][:setting_attributes][:created_time] = fb_application['created_time']
      params[:social_app][:setting_attributes][:user_support_email] = fb_application['user_support_email']
      params[:social_app][:setting_attributes][:creator_uid] = fb_application['creator_uid']
      params[:social_app][:setting_attributes][:canvas_url] = fb_application['canvas_url']
      params[:social_app][:setting_attributes][:website_url] = fb_application['website_url']
    end

    params[:social_app][:user_id] = current_admin.id
    params[:social_app][:provider] = 'facebook'
    @social_app = SocialApp.new(params[:social_app])

    respond_to do |format|
      if fb_application and @social_app.save
        format.html { redirect_to @social_app, notice: 'Social app was successfully created.' }
        format.json { render json: @social_app, status: :created, :location => @social_app }
      else
        format.html { render action: "new" }
        format.json { render json: @social_app.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_permissions(permissions)
    set_user_permissions = Array.new
    set_user_permissions << 'email'
    ["publish_stream", "offline_access", "manage_pages", "create_event", "rsvp_event", "xmpp_login"].each do |permission|
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
    fb_application = get_application_info(params[:social_app][:setting_attributes][:facebook_id], params[:social_app][:setting_attributes][:facebook_secret])
    if fb_application
      params[:social_app][:setting_attributes][:permissions] = set_permissions(params[:social_app][:setting_attributes])
      params[:social_app][:name] = fb_application['name']
      params[:social_app][:setting_attributes][:callback_url] = get_callback_url(fb_application['name'])
      params[:social_app][:setting_attributes][:icon_url] = fb_application['icon_url']
      params[:social_app][:setting_attributes][:canvas_name] = fb_application['canvas_name']
      params[:social_app][:setting_attributes][:link] = fb_application['link']
      params[:social_app][:setting_attributes][:logo_url] = fb_application['logo_url']
      params[:social_app][:setting_attributes][:namespace] = fb_application['namespace']
      params[:social_app][:setting_attributes][:contact_email] = fb_application['contact_email']
      params[:social_app][:setting_attributes][:created_time] = fb_application['created_time']
      params[:social_app][:setting_attributes][:user_support_email] = fb_application['user_support_email']
      params[:social_app][:setting_attributes][:creator_uid] = fb_application['creator_uid']
      params[:social_app][:setting_attributes][:canvas_url] = fb_application['canvas_url']
      params[:social_app][:setting_attributes][:website_url] = fb_application['website_url']
    end


    respond_to do |format|
      if @social_app.update_attributes(params[:social_app]) and fb_application
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

  def get_application_info(app_id, app_secret)
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret)
    app_access_token = @oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(app_access_token)
    begin
      resp = @graph.get_object(app_id, {:access_token => app_access_token, :fields => 'id, canvas_url, name, description, canvas_name, category, company, icon_url, subcategory, link, logo_url, daily_active_users, weekly_active_users, monthly_active_users, migrations, namespace, app_domains, auth_dialog_data_help_url, auth_dialog_description, auth_dialog_headline, auth_dialog_perms_explanation, auth_referral_user_perms, auth_referral_friend_perms, auth_referral_default_activity_privacy, auth_referral_enabled, auth_referral_extended_perms, auth_referral_response_type, canvas_fluid_height, canvas_fluid_width, contact_email, created_time, creator_uid, deauth_callback_url, iphone_app_store_id, hosting_url, mobile_web_url, page_tab_default_name, page_tab_url, privacy_policy_url, secure_canvas_url, secure_page_tab_url, server_ip_whitelist, social_discovery, terms_of_service_url, user_support_email, user_support_url, website_url'}, {:use_ssl => true})
    rescue Exception => e
      resp = nil
    end
    resp
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
