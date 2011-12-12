class CreateCountriesTable < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :name
      t.boolean :active
      t.timestamps
    end
  end

  def down
  end
end
