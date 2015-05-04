class BoatListingAdapter
  # order is important... duh
  #ATTRS_AND_SCALE = {
  #  :length => 1.0,
  #  :year_of_boat => 1.0,
  #  :listed_price => 1.0
  #}
  ATTRS_AND_SCALE = {
    :length => 30.044701744901595,
    :year_of_boat => 54.53739061371652,
    :listed_price => 90.29849184001706
  }

  def initialize(boat_listings)
    @boat_listings = boat_listings
  end

  def training_set
    @training_set ||= generate_training_set
  end

  def query_for(new_listing)
    data_vector_for(new_listing)
  end

  def self.scale_vector
    ATTRS_AND_SCALE.values
  end

  private
  def generate_training_set
    listings = []
    @boat_listings.each do |listing|
      datum = {
        value: listing.sold_price,
        attributes: data_vector_for(listing)
      }
      listings << datum if valid_datum?(datum)
    end
    listings
  end

  def data_vector_for(listing)
    ATTRS_AND_SCALE.keys.map do |attr|
      listing.send(attr)
    end
  end

  def valid_datum?(datum)
    return false if datum[:value].nil?
    return false if datum[:attributes].any?(&:nil?)
    true
  end
end
