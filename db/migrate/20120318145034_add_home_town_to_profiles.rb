class AddHomeTownToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :home_town, :string
  end
end
