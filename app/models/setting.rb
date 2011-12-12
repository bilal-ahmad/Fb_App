class Setting < ActiveRecord::Base
  belongs_to :social_app
  attr_accessor :publish_stream,:email, :offline_access, :manage_pages, :create_event, :rsvp_event, :xmpp_login
end
