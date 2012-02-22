class CreateWelcomePost < ActiveRecord::Migration
  def up
    add_column :social_posts, :post_type, :string
    SocialPost.create :post_type => "welcome"
  end

  def down
  end
end
