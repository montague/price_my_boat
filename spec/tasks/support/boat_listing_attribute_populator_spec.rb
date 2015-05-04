require 'spec_helper'
require 'fixtures/readonly_boat_listings'

describe BoatListingAttributePopulator do
  it "sets the attributes of boat listings" do
    populator = BoatListingAttributePopulator.new([
      BoatListing.new(yw_data: UNPOPULATED_READONLY_LISTINGS.first.yw_data),
      BoatListing.new(yw_data: UNPOPULATED_READONLY_LISTINGS.second.yw_data)
    ])
    populator.populate!
    first, second = populator.listings

    # first listing
    expect(first.length).to eq 39
    expect(first.year_of_boat).to eq 2003
    expect(first.listed_price).to eq 158800
    expect(first.sold_price).to eq 135000
    expect(first.date_listed).to eq parse_date("09/11")
    expect(first.date_sold).to eq parse_date("11/11")
    expect(first.location).to eq "MA, United States"
    expect(first.hull_material).to eq "Fiberglass"
    expect(first.engine_fuel_type).to eq "Twin diesel"
    expect(first.headline).to eq "39' Mainship 390 Trawler - Twin diesels"

    # second listing
    expect(second.length).to eq 36
    expect(second.year_of_boat).to eq 1985
    expect(second.listed_price).to eq 36900
    expect(second.sold_price).to eq 33000
    expect(second.date_listed).to eq parse_date("05/12")
    expect(second.date_sold).to eq parse_date("06/12")
    expect(second.location).to eq "MD, United States"
    expect(second.hull_material).to eq "Fiberglass"
    expect(second.engine_fuel_type).to eq "Twin Gas"
    expect(second.headline).to eq "Trojan 36 Tri-Cabin"
  end

  it "keeps track of listings that have errors" do
    good_listing = BoatListing.new(yw_data: UNPOPULATED_READONLY_LISTINGS.first.yw_data)
    bad_listing = BoatListing.new(yw_data: "<h1>BAD DATA! BAD!!</h1>")
    populator = BoatListingAttributePopulator.new(good_listing, bad_listing)
    populator.populate!

    expect(populator.bad_listings).to match_array [bad_listing]
  end

  it "passes the each listing to a block if specified" do
    listing = BoatListing.new
    populator = BoatListingAttributePopulator.new(listing)
    populator.after_populate_callback = ->(listing) { listing.yw_data = 'omg' }
    populator.populate!

    expect(populator.listings.first.yw_data).to eq "omg"
  end
end
