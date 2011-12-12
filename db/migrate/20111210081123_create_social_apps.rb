class CreateSocialApps < ActiveRecord::Migration
  def change
    create_table :social_apps do |t|
      t.integer :user_id
      t.string :name
      t.string :provider

      t.timestamps
    end
  end
end
