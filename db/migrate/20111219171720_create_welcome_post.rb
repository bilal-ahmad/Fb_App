class CreateWelcomePost < ActiveRecord::Migration
  def up
    execute "INSERT INTO social_posts  VALUES (5, 'welcome', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);"
  end

  def down
  end
end
