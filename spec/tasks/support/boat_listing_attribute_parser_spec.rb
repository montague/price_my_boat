require 'spec_helper'
require 'fixtures/readonly_boat_listings'

describe BoatListingAttributeParser do
  before :all do
    @listings = UNPOPULATED_READONLY_LISTINGS.map do |listing|
      BoatListingAttributeParser.new(listing.yw_data)
    end
  end

  it "parses brand and style" do
    headlines = @listings.map(&:headline)
    expected_headlines = [
      "39' Mainship 390 Trawler - Twin diesels", "Trojan 36 Tri-Cabin",
      "Sea Ray 400 Sedan Bridge", "Mainship Motor Yacht",
      "Sea Ray 185 Bowrider like new", "Bayliner 3055 Ciera",
      "Bayliner 185 Flight", "Pro-Line 231 WA", "Key West 17 Center Console",
      "Triton 18", nil
    ]

    expect(headlines).to match_array expected_headlines
  end

  it "parses engine/fuel type" do
    engine_fuel_types = @listings.map(&:engine_fuel_type)
    expected_engine_fuel_types = [
      "Twin diesel", "Twin Gas", "Twin diesel", "Twin diesel",
      "Single Gas", "Twin Gas", "Single Gas", "Single Gas",
      "Single Gas", "Single Gas", nil
    ]

    expect(engine_fuel_types).to match_array expected_engine_fuel_types
  end

  it "parses hull material" do
    hull_materials = @listings.map(&:hull_material)
    expected_hull_materials = (["Fiberglass"] * 10) << nil

    expect(hull_materials).to match_array expected_hull_materials
  end

  it "parses location" do
    locations = @listings.map(&:location)
    expected_locations = [
      "MA, United States", "MD, United States", "Winthrop Harbor, IL",
      "Port of Everett Marina, WA", "Naples, FL", "Red Wing, MN",
      "Ashland, VA", "Naples, FL", "Destin, FL", "Hendersonville, TN",
      nil
    ]

    expect(locations).to match_array expected_locations
  end

  it "parses date sold" do
    dates_sold = @listings.map(&:date_sold)
    expected_dates = [
      parse_date("11/11"), parse_date("06/12"), parse_date("10/12"),
      parse_date("05/11"), parse_date("08/11"), parse_date("05/11"),
      parse_date("07/12"), parse_date("03/13"), parse_date("08/12"),
      parse_date("11/11"), nil
    ]

    expect(dates_sold).to match_array expected_dates
  end

  it "parses date listed" do
    dates_listed = @listings.map(&:date_listed)
    expected_dates = [
      parse_date("09/11"), parse_date("05/12"), parse_date("08/12"),
      parse_date("06/10"), parse_date("02/11"), parse_date("07/10"),
      parse_date("05/12"), parse_date("02/13"), parse_date("06/12"),
      parse_date("11/11"), nil
    ]

    expect(dates_listed).to match_array expected_dates
  end

  it "parses length" do
    lengths = @listings.map(&:length)

    expect(lengths).to match_array [39, 36, 40, 37, 18, 30, 18, 23, 17, 18, nil]
  end

  it "parses year" do
    years = @listings.map(&:year_of_boat)

    expect(years).to match_array [2003, 1985, 2000, 1996, 2002, 1999, 2010, 1994, 2002, 2001, nil]
  end

  it "parses listed price" do
    listed_prices = @listings.map(&:listed_price)
    expected_prices = [
      158800, 36900, 185900, 119900, 12900,
      49900, 19900, 8995, 900, 9111900, nil
    ]

    expect(listed_prices).to match_array expected_prices
  end

  it "parses sold price" do
    sold_prices = @listings.map(&:sold_price)
    expected_prices = [
      135000, 33000, 165000, 75000, 11000,
      45000, 18300, 8000, 500, 7228800, nil
    ]

    expect(sold_prices).to match_array expected_prices
  end
end
