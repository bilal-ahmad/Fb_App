class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :link, :add, :get_facebook_profile, :facebook_authorize]
  require "koala"
  def index
    @authentications = current_user.authentications if current_user
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authentications }
    end
  end

  def new
    @authentication = Authentication.new
  end

  def add
    user = User.find(params[:user_id])
    if user.valid_password?(params[:user][:password])
      omniauth = session[:omniauth]
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      session[:omniauth] = nil
      sign_in_and_redirect(:user, user)
    else
      flash[:notice] = "Incorrect Password"
      return redirect_to link_accounts_url(user.id)
    end
  end

  def link
    @user = User.find(params[:user_id])
  end

  # TODO: Account linking. Example, if a user has signed in via twitter using the
  # email abc@xyz.com and then signs in via Facebook with the same id, we should
  # link these 2 accounts. Since, we already have Authentication model in place,
  # user should be asked for login credentials and then the new authentication should
  # be linked.

  def create
    if !request.env['omniauth.auth'].blank?
      omniauth = request.env['omniauth.auth']
      session[:oauth_token] = omniauth['credentials']['token']
      authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      oauth_token = omniauth[:credentials][:token]
    elsif !params[:code].blank?
      code = params[:code]
      omniauth = get_facebook_profile(code)
      omniauth['provider'] = "facebook"
      omniauth['uid'] = omniauth['id']
      oauth_token = omniauth['oauth_token']
      authentication = Authentication.find_by_provider_and_uid_and_social_app_id(omniauth['provider'], omniauth['uid'], omniauth['social_app_id'])
    end
    if authentication and !authentication.user.nil?
      if !authentication.user.profile.authorize? or !authentication.user.profile.app_status?
        authentication.user.profile.update_attributes(:oauth_token => oauth_token, :authorize => true, :app_status => true)
        welcome_post(oauth_token)
      end
      flash[:notice] = "Signed in successfully"

      #sign_in_and_redirect(:user, authentication.user)
      sign_in(:user, authentication.user)
      if omniauth['canvas_url'].present?
        url = get_auth_app_url(params[:app_name])
        #redirect_to get_auth_app_url(params[:app_name])
        redirect_to "http://apps.facebook.com/kill-thrill-two/?user=cc"
      else
        redirect_to root_path(:user => "cc")
      end
    else
      user = User.new
      user.apply_omniauth(omniauth)
      Rails.logger.info "*********************"
      email = omniauth['email']
      email = omniauth['social_app_id'] + email.to_s
      Rails.logger.info email
      Rails.logger.info omniauth['social_app_id']

      user.email = omniauth['extra'] && omniauth['extra']['raw_info'] && omniauth['extra']['raw_info']['email'] || email
      user.password = Devise.friendly_token[0,20]
      if user.save
        create_facebook_profile(user, omniauth)
        welcome_post(oauth_token)
        flash[:notice] = "Successfully registered"
        sign_in(:user, user)
        #redirect_to get_auth_app_url
        if omniauth['canvas_url'].present?
          redirect_to get_auth_app_url(params[:app_name])
        else
          redirect_to root_path(:user => "cc")
        end
      else
        session[:omniauth] = omniauth.except('extra')
        session[:omniauth_email] = omniauth['extra'] && omniauth['extra']['user_hash'] && omniauth['extra']['user_hash']['email']

        # Check if email already taken. If so, ask user to link_accounts
        if user.errors[:email][0] =~ /has already been taken/ # omniauth? TBD
                                                              # fetch the user with this email id!
          user = User.find_by_email(user.email)
          return redirect_to link_accounts_url(user.id)
        end
        redirect_to new_user_registration_url(:oauth =>  true)
      end
    end
  end

  def facebook_authorize
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}

    @app = SocialApp.find_by_name(params[:app_name])
    Rails.logger.info "******************"
    Rails.logger.info params[:app_name]
    callback_url = @app.setting.callback_url
    app_id = @app.setting.facebook_id
    app_secret = @app.setting.facebook_secret
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    if @oauth
      @url = @oauth.url_for_oauth_code(:permissions => "#{@app.setting.permissions}")
      redirect_url =<<-EOS
    <script>
      top.location.href="#{@url}";
    </script>
      EOS
      render :inline => redirect_url
    else
      error = "Application not find."
      redirect_to facebook_error_path(error)
    end

  end


  def get_facebook_profile(code)
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @app = SocialApp.find_by_name(params[:app_name])
    callback_url = @app.setting.callback_url
    app_id = @app.setting.facebook_id
    app_secret = @app.setting.facebook_secret
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    oauth_access_token = @oauth.get_access_token(code)
    @graph = Koala::Facebook::GraphAPI.new(oauth_access_token)
    profile = @graph.get_object("me")
    profile['image'] = @graph.get_picture("me")
    profile['oauth_token'] = oauth_access_token
    profile['social_app_id'] = @app.id
    profile['canvas_url'] = @app.setting.canvas_url
    profile
  end

  def create_facebook_profile(user, omniauth)
    user_id = user.id
    social_app_id = omniauth['social_app_id']
    oauth_token = omniauth['oauth_token'].present? ? omniauth['oauth_token'] : omniauth['credentials']['token']
    name = is_info_exist(omniauth, 'name')
    first_name = is_info_exist(omniauth, 'first_name')
    last_name = is_info_exist(omniauth, 'last_name')
    image = is_info_exist(omniauth, 'image')
    if omniauth['location'].present?
      location = omniauth['location']['name']
      city = location.present? ? location.split(",").first : ""
      country = location.present? ? location.split(",").second : ""
    else
      location = ""
      city = ""
      country = ""
    end
    gender = is_info_exist(omniauth, 'gender')
    time_zone = is_info_exist(omniauth, 'timezone')
    profile_link = is_info_exist(omniauth, 'link')
    Profile.create( :user_id => user_id, :social_app_id => social_app_id, :oauth_token => oauth_token, :name => name, :first_name => first_name,
                    :last_name => last_name, :image =>image,
                    :location => location, :city => city,
                    :country => country.strip, :profile_link => profile_link,
                    :gender => gender, :time_zone => time_zone, :app_status => true)
  end

  def failure
    flash[:alert] = params[:message]
    redirect_to new_session_path(flash[:alert])
  end

  def welcome_post(oauth_token)
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @welcome_post = SocialPost.find_by_post_type("welcome")
    name = @welcome_post.name
    link = @welcome_post.link
    caption = @welcome_post.caption
    description = @welcome_post.description
    picture = @welcome_post.picture
    begin
      @graph = Koala::Facebook::GraphAPI.new(oauth_token)
      @graph.put_wall_post( description, {:name => name, :link => link, :caption => caption,  :picture => picture})
    rescue
      flash[:error] = "There is some error in post"
    end
  end

  def de_authorize_facebook_app
    p "****************************"
    Rails.logger.info params
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to(authentications_url) }
      format.xml  { head :ok }
    end
  end


end
