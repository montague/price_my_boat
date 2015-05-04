class AddFieldsToBoatListings < ActiveRecord::Migration
  def change
    add_column :boat_listings, :length, :integer
    add_column :boat_listings, :year_of_boat, :integer
    add_column :boat_listings, :listed_price, :integer
    add_column :boat_listings, :sold_price, :integer
    add_column :boat_listings, :date_listed, :datetime
    add_column :boat_listings, :date_sold, :datetime
    add_column :boat_listings, :location, :string
    add_column :boat_listings, :hull_material, :string
    add_column :boat_listings, :engine_fuel_type, :string
    add_column :boat_listings, :headline, :string
  end
end
