class AddUserIdToSocialPosts < ActiveRecord::Migration
  def change
    add_column :social_posts, :user_id, :integer
  end
end
