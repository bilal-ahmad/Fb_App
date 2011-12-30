
class Profile < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  has_many :authentications, :through  => :user
  self.per_page = 30
end
