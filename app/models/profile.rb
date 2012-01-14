
class Profile < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :social_app
  has_many :authentications, :through  => :user
  self.per_page = 500
end
