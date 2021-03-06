class SocialPost < ActiveRecord::Base
  attr_accessor :country, :all_countries
  validates :name, :description, :presence => true, :on => :post
  belongs_to :user
end
