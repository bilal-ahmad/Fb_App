class AddSocialAppFieldToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :social_app_id, :integer
  end
end
