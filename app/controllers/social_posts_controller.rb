class SocialPostsController < ApplicationController
  before_filter :authenticate_admin!, :except => :show
  # GET /social_posts
  # GET /social_posts.json
  require "koala"

  def index
    if params[:post_type] == "photo"
      @photo_posts = SocialPost.find_all_by_post_type("photo")
    else
      @posts = SocialPost.find_all_by_post_type("post")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @social_posts }
    end
  end

  # GET /social_posts/1
  # GET /social_posts/1.json
  def show
    @social_post = SocialPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @social_post }
    end
  end

  # GET /social_posts/new
  # GET /social_posts/new.json
  def new
    @countries = SocialPost.find_by_sql("SELECT name FROM countries WHERE active = true")
    @apps = SocialApp.all
    @facebook_accounts = Profile.find_all_by_authorize true
    @social_post = SocialPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @social_post }
    end
  end

  # GET /social_posts/1/edit
  def edit
    @social_post = SocialPost.find(params[:id])
    @countries = SocialPost.find_by_sql("SELECT name FROM countries WHERE active = true")
    @apps = SocialApp.all
    @facebook_accounts = Profile.find_all_by_authorize true
  end

  # POST /social_posts
  # POST /social_posts.json
  def create
    @social_post = SocialPost.new(params[:social_post])
    @facebook_accounts = Profile.find_all_by_authorize true

    respond_to do |format|
      if params[:countries].present? or params[:apps].present?
        if @social_post.save
          if params[:sap].present?
            post(params)
            @countries = SocialPost.find_by_sql("SELECT name FROM countries WHERE active = true")
            format.html { render action: "new" , :notice => 'Social post was successfully drafted.' }
          end
          format.json { render json: @social_post, status: :created, location: @social_post }
        else
          format.html { render action: "new" }
          format.json { render json: @social_post.errors, status: :unprocessable_entity }
        end
      else
        flash[:error] = "Select the country or Facebook Account"
        format.html { render action: "new" }
      end
    end
  end



  # PUT /social_posts/1
  # PUT /social_posts/1.json
  def update
    @social_post = SocialPost.find(params[:id])
    @countries = SocialPost.find_by_sql("SELECT name FROM countries WHERE active = true")
    @apps = SocialApp.all

    respond_to do |format|
      if params[:countries].present? or params[:apps].present?
          if @social_post.update_attributes(params[:social_post])
            if params[:sap].present?
              post(params)
              flash[:notice] = 'Social post was successfully posted to wall and drafted.'
              format.html { render action: "edit"  }
            else
              flash[:notice] = 'Social post was successfully drafted.'
              format.html { render action: "edit"  }
              format.json { head :ok }
            end
          else
            format.html { render action: "edit" }
            format.json { render json: @social_post.errors, status: :unprocessable_entity }
          end
      else
        flash[:error] = "Select the Country"
        format.html { render action: "edit" }
      end
    end

  end

  # DELETE /social_posts/1
  # DELETE /social_posts/1.json
  def destroy
    @social_post = SocialPost.find(params[:id])
    @social_post.destroy

    respond_to do |format|
      format.html { redirect_to social_posts_url }
      format.json { head :ok }
    end
  end

  def new_photo_post
    @social_post = SocialPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @social_post }
    end
  end

  def edit_welcome_post
    @social_post = SocialPost.find_by_post_type("welcome")
  end

  def edit_default_post
    @social_post = SocialPost.find_by_post_type("default")
  end



  def update_welcome_post
    @social_post = SocialPost.find_by_post_type("welcome")
    respond_to do |format|
      if @social_post.update_attributes(params[:social_post])
        format.html { render action: "edit_welcome_post" , :notice => 'Welcome post was successfully drafted.' }
        format.json { head :ok }
      else
        format.html { render action: "edit_welcome_post" }
        format.json { render json: @social_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_default_post
    @social_post = SocialPost.find_by_post_type("default")
    respond_to do |format|
      if @social_post.update_attributes(params[:social_post])
        format.html { render action: "edit_default_post" , :notice => 'Default post was successfully drafted.' }
        format.json { head :ok }
      else
        format.html { render action: "edit_default_post" }
        format.json { render json: @social_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def photo_post
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @graph = Koala::Facebook::GraphAPI.new(current_user.profile.oauth_token)
    result = @graph.put_picture("http://graph.facebook.com/100001772685920/picture?type=square", {:message => "my first post"}, "me")
    result
  end



  def post(params)
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    options = {
        :name => params[:social_post][:name],
        :link => params[:social_post][:link],
        :caption => params[:social_post][:caption],
        :description => params[:social_post][:description],
        :picture => params[:social_post][:picture]
    }
    post_by_countries(params[:countries], options) if params[:countries].present?
    post_by_app(params[:apps].join(","), options)

  end

  def post_by_app(apps, options)
    apps = SocialApp.where("id IN (?)", apps)
    apps.each do |app|
      users =  Profile.where("social_app_id AND authorize AND app_status", app.id, true, true)
      users.each do |user|
        post_to_wall(user, options)
      end
    end
  end

  def post_by_countries(countries, options)
    countries = (countries.present? and countries == "all") ? "all" : countries
    countries.each do |country|
      countries.first == "all" ? (user =  Profile.find_all_by_authorize_and_app_status(true, true)) : (user =  Profile.find_all_by_country_and_authorize_and_app_status(country, true, true))
      if !user.nil? and user.count == 1
        post_to_wall(user, options)
      elsif !user.nil? and user.count > 1
        users = user
        users.each do |user|
          post_to_wall(user, options)
        end
      end
    end
  end


  def post_by_person
    #@facebook_accounts = Profile.find_all_by_authorize true

    #if params[:facebook_accounts].nil?

    #else
    #  if params[:facebook_accounts].size > 1
    #    facebook_accounts = params[:facebook_accounts].join(",")
    #  else
    #    facebook_accounts = params[:facebook_accounts].first
    #  end
    #  fb_users = Profile.where("id IN (#{facebook_accounts})")
    #  fb_users.each do |user|
    #    post_to_wall(user, options)
    #  end
    #end

  end

  def ajax_post
    if params.present?
      Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
      post_type = params[:post_type]
      users = params[:users].join(",") if params[:users].present?
      users.present? and users.size > 1 ? (users =  Profile.where("id IN (#{users})")) : (users =  Profile.where("id IN (#{params[:users].first})"))
      post = SocialPost.find_all_by_post_type(post_type).first
      options = {
          :name => post.name,
          :link => post.link,
          :caption => post.caption,
          :description => post.description,
          :picture => post.picture
      }
      users.each do |user|
        post_to_wall(user, options)
      end
      render json: "true"
    end

  end


  def post_to_wall(user, options)
    @graph = Koala::Facebook::API.new(user.oauth_token)
    begin
      @graph.put_wall_post( options[:description], {:name => options[:name], :link => options[:link], :caption => options[:caption],  :picture => options[:picture]})
    rescue Exception => e
      case e.message
        when /Duplicate status message/
          user.update_attribute(:error, e.message)
        when /Error validating access token/
          user.update_attributes(:authorize => false, :error => e.message)
        else
          user.update_attribute(:error, e.message)
      end
    end
  end

end
