class AddSocialAppIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :social_app_it, :integer
  end
end
