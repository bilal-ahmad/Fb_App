class SocialApp < ActiveRecord::Base
  has_one :setting
  belongs_to :user
  accepts_nested_attributes_for :setting
end
