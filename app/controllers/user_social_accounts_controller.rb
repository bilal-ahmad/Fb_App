class UserSocialAccountsController < ApplicationController
  before_filter :authenticate_admin!
  require 'koala'

  def post_to_facebook
    Koala.http_service.http_options = {:ssl => { :ca_file => Rails.root.join('lib/assets/cacert.pem').to_s }}
    @graph = Koala::Facebook::GraphAPI.new(session[:oauth_token])
    @graph.put_wall_post("hey, i'm learning kaola")

  end



end
