class SocialPostsController < ApplicationController
  before_filter :authenticate_user!
  # GET /social_posts
  # GET /social_posts.json
  require "koala"

  def index
    @social_posts = SocialPost.all

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
    @social_post = SocialPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @social_post }
    end
  end

  # GET /social_posts/1/edit
  def edit
    @social_post = SocialPost.find(params[:id])
  end

  # POST /social_posts
  # POST /social_posts.json
  def create
    @social_post = SocialPost.new(params[:social_post])

    respond_to do |format|
      if @social_post.save
        format.html { redirect_to @social_post, notice: 'Social post was successfully created.' }
        format.json { render json: @social_post, status: :created, location: @social_post }
      else
        format.html { render action: "new" }
        format.json { render json: @social_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /social_posts/1
  # PUT /social_posts/1.json
  def update
    @social_post = SocialPost.find(params[:id])

    respond_to do |format|
      if @social_post.update_attributes(params[:social_post])
        format.html { redirect_to @social_post, notice: 'Social post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @social_post.errors, status: :unprocessable_entity }
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

  def post_to_wall(app_id, app_secret, subject, body)
    require "koala"

    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @graph = Koala::Facebook::GraphAPI.new(session[:oauth_token])
    @graph.put_wall_post("hey, i'm learning kaola")

  end

  def new_photo_post
    @social_post = SocialPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @social_post }
    end
  end

  def photo_post
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @graph = Koala::Facebook::GraphAPI.new(current_user.profile.oauth_token)
    result = @graph.put_picture("http://graph.facebook.com/100001772685920/picture?type=square", {:message => "my first post"}, "me")
    result
  end

  def new_post
    @countries = SocialPost.find_by_sql("SELECT name FROM countries WHERE active = true")
    @social_post = SocialPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @social_post }
    end
  end

  def post
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    name = params[:social_post][:name]
    link = params[:social_post][:link]
    caption = params[:social_post][:caption]
    description = params[:social_post][:description]
    picture = params[:social_post][:picture]
    users = Array.new
    begin
    if params[:countries].present?
      params[:countries].each do |country|
        users << Profile.find_all_by_country(country) if !Profile.find_all_by_country(country).blank?
      end
      users.each do |user|
        @graph = Koala::Facebook::GraphAPI.new(user[0].oauth_token)
        @graph.put_wall_post( description, {:name => name, :link => link, :caption => caption,  :picture => picture})
      end
        flash[:notice] = "Successfully posted to the walls"
        redirect_to new_post_path
    else
      flash[:error] = "Select the country"
      redirect_to new_post_path
    end
    rescue
       flash[:error] = "There is some error in post"
      redirect_to new_post_path
    end
  end

end
