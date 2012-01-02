class AddErrorFiledToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :error, :string, :limit => 500
  end
end
