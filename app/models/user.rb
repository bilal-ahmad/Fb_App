class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :authentications, :dependent => :delete_all
  has_one :profile
  has_many :social_apps

  def apply_omniauth(omniauth)
    provider = omniauth['provider']
    social_account_user_id = omniauth['uid']
    #name = is_info_exist(omniauth, 'name')
    #first_name = is_info_exist(omniauth, 'first_name')
    #last_name = is_info_exist(omniauth, 'last_name')
    #image = is_info_exist(omniauth, 'image')
    #location = is_info_exist(omniauth, 'location')
    #city = location.present? ? location.split(",").first : ""
    #country = location.present? ? location.split(",").second : ""
    #gender = is_info_exist(omniauth, 'gender')
    #time_zone = is_info_exist(omniauth, 'timezone')
    #profile_link = is_info_exist(omniauth, 'link')
    authentications.build(:provider => provider, :uid => social_account_user_id)
#    user.profile.build(:name => name, :first_name => first_name,
#                  :last_name => last_name, :image =>image,
#                  :location => location, :city => city,
#                  :country => country, :profile_link => profile_link,
#                  :gender => gender, :time_zone => time_zone)
  end



  def password_required?
    (authentications.empty? || !password.blank?) && super
  end


end
