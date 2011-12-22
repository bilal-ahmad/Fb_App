class AddAuthorizeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :authorize, :boolean, :default => 1
  end
end
