class AddFieldToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :app_status, :boolean
  end
end
