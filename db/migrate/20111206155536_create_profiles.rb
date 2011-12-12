class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :name
      t.string :oauth_token
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :city
      t.string :country
      t.string :image
      t.string :gender
      t.string :profile_link
      t.string :time_zone

      t.timestamps
    end
  end
end
