class CreateWelcomePost < ActiveRecord::Migration
  def up
    execute "INSERT INTO social_posts (id, post_type, name, link, picture, caption, description, message, wall_post, status_update, chatt_message, photo_message, photo_path, welcome_status_message, created_at, updated_at, user_id) VALUES (NULL, welcome, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);"
  end

  def down
  end
end
