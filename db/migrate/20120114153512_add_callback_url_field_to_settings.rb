class AddCallbackUrlFieldToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :callback_url, :string
  end
end
