class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :canvas_url
      t.string :deauthorize_callback_url
      t.string :type
      t.string :status
      t.string :name
      t.string :facebook_id
      t.string :facebook_secret
      t.string :facebook_canvas_page
      t.string :tiny_url
      t.string :event_id
      t.string :event_message
      t.string :event_rsvp
      t.string :permissions


      t.timestamps
    end
  end
end
