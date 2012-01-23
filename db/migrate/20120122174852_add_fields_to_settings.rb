class AddFieldsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :canvas_name, :string
    add_column :settings, :icon_url, :string
    add_column :settings, :link, :string
    add_column :settings, :logo_url, :string
    add_column :settings, :namespace, :string
    add_column :settings, :contact_email, :string
    add_column :settings, :creator_uid, :string
    add_column :settings, :user_support_email, :string
    add_column :settings, :created_time, :string
  end
end
