class CreateSocialPosts < ActiveRecord::Migration
  def change
    create_table :social_posts do |t|
      t.string :name
      t.string :link
      t.string :picture
      t.string :caption
      t.string :description
      t.string :message
      t.string :wall_post
      t.string :status_update
      t.string :chatt_message
      t.string :photo_message
      t.string :photo_path
      t.string :welcome_status_message

      t.timestamps
    end
  end
end
