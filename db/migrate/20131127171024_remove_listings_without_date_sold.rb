class RemoveListingsWithoutDateSold < ActiveRecord::Migration
  def up
    listings = BoatListing.where(:date_listed => nil).destroy_all
    say "deleted #{listings.count} listings that had no date_sold value."
  end

  def down
    say "listings without a date_sold value have been deleted. cannot be undone."
  end
end
