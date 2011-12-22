class CreateWelcomePost < ActiveRecord::Migration
  def up
    SocialPost.create :post_type => "welcome"
  end

  def down
  end
end
