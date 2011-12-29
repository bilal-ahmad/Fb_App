
class Profile < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  self.per_page = 30
end
