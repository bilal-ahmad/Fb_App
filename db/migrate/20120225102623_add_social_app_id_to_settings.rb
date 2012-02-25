class AddSocialAppIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :social_app_id, :integer
  end
end
