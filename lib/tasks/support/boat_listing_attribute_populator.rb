class BoatListingAttributePopulator
  EXPECTED_ATTRS = %w(
                      length year_of_boat listed_price sold_price
                      date_listed date_sold location hull_material
                      engine_fuel_type headline
                     )

  attr_reader :listings, :bad_listings
  attr_writer :after_populate_callback

  def initialize(*args)
    args.flatten!
    @listings = args
    @bad_listings = []
  end

  def populate!
    @listings.each do |listing|
      parsed_attrs = BoatListingAttributeParser.new(listing.yw_data)
      EXPECTED_ATTRS.each do |attr|
        listing.send("#{attr}=", parsed_attrs.send(attr))
      end
      add_to_bad_listings_if_necessary(listing)
      @after_populate_callback.call(listing) if @after_populate_callback
    end
  end

  private
  def add_to_bad_listings_if_necessary(listing)
    if EXPECTED_ATTRS.select{ |attr| listing.send(attr).nil? }.any?
      @bad_listings << listing
    end
  end
end
