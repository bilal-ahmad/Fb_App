class SocialApp < ActiveRecord::Base
  has_one :setting
  belongs_to :user
  has_many :profiles
  has_many :authentications
  accepts_nested_attributes_for :setting
end
