class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :event_type
      t.string :embed
      t.string :description
      t.string :image
      t.boolean  :active

      t.timestamps
    end
  end
end
