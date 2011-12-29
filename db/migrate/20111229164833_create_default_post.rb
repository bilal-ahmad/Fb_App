class CreateDefaultPost < ActiveRecord::Migration
  def up
    SocialPost.create :post_type => "default"
  end

  def down
  end

end
