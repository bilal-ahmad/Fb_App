class CreateWelcomePost < ActiveRecord::Migration
  def up
    execute "INSERT INTO social_posts (`post_type`) VALUES ('welcome');"
  end

  def down
  end
end
