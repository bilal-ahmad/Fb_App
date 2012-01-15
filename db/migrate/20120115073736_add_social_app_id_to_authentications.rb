class AddSocialAppIdToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :social_app_id, :integer
  end
end
