class Authentication < ActiveRecord::Base
  attr_accessible :user_id, :provider, :uid, :social_app_id
  belongs_to :user, :dependent => :destroy
  belongs_to :social_app

  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end
end
