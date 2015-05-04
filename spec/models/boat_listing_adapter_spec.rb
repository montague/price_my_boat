require 'spec_helper'
require 'fixtures/readonly_boat_listings'

describe BoatListingAdapter do
  before do
    @listings = [
      BoatListing.new(
        length: 50,
        year_of_boat: 2010,
        listed_price: 500000,
        sold_price: 480000
      ),
      BoatListing.new(
        length: 30,
        year_of_boat: 2000,
        listed_price: 45000,
        sold_price: 42000
      )
    ]
  end

  describe '#query_for' do
    it 'returns a data vector for a listing' do
      adapter = BoatListingAdapter.new([])

      expect(adapter.query_for(@listings.first)).to match_array [50, 2010, 500000]
    end
  end

  describe '#training_set' do
    it 'turns boat listings into a usable training set' do
      adapter = BoatListingAdapter.new(@listings)
      expected_training_set = [
        {
          value: 480000,
          attributes: [50, 2010, 500000]
        },
        {
          value: 42000,
          attributes: [30, 2000, 45000]
        }
      ]
      expect(adapter.training_set).to match_array expected_training_set
    end

    it 'discards incomplete data' do
      @listings.last.length = nil
      adapter = BoatListingAdapter.new(@listings)
      expected_training_set = [
        {
          value: 480000,
          attributes: [50, 2010, 500000]
        }
      ]

      expect(adapter.training_set).to match_array expected_training_set
    end
  end
end
