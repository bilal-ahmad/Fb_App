class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :authentications, :dependent => :delete_all
  has_one :profile
  has_many :social_apps
  has_many :social_posts

  def apply_omniauth(omniauth)
    provider = omniauth['provider']
    social_account_user_id = omniauth['uid']
    authentications.build(:provider => provider, :uid => social_account_user_id)
  end



  def password_required?
    (authentications.empty? || !password.blank?) && super
  end


end
