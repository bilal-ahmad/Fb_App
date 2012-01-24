class AddWebSiteFieldToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :website_url, :string
  end
end
