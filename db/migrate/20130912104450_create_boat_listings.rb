class CreateBoatListings < ActiveRecord::Migration
  def change
    create_table :boat_listings do |t|
      t.string :yw_id, :null => false
      t.text :yw_data
      t.timestamps
    end
    add_index :boat_listings, :yw_id, :unique => true
  end
end
