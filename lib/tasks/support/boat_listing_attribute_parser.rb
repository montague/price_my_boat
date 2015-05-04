class BoatListingAttributeParser
  DATE_FORMAT = "%m/%y"

  attr_reader *[
    :length, :year_of_boat, :listed_price, :sold_price,
    :date_listed, :date_sold, :location, :hull_material,
    :engine_fuel_type, :headline
  ]

  def initialize(raw_xml_data)
    @data = raw_xml_data
    @length = parse_length
    @year_of_boat = parse_year_of_boat
    @listed_price = parse_listed_price
    @sold_price = parse_sold_price
    @date_listed = parse_date_listed
    @date_sold = parse_date_sold
    @location = parse_location
    @hull_material = parse_hull_material
    @engine_fuel_type = parse_engine_fuel_type
    @headline = parse_headline
  end

  private
  def parse_headline
    @data =~ /<h3>\d+' (.*)<\/h3>/
    $1
  end

  def parse_engine_fuel_type
    @data =~ /<li>Engine\/Fuel Type: (.*?)<\/li>/
    $1
  end

  def parse_hull_material
    @data =~ /<li>Hull Material: (.*?)<\/li>/
    $1
  end

  def parse_location
    @data =~ /<li>Located in (.*?)<\/li>/
    $1
  end

  def parse_date_sold
    @data =~ /Sold:.*?\((\d{2}\/\d{2})\)/
    parse_date($1) if $1
  end

  def parse_date_listed
    @data =~ /Last Listed Price:.*?\((\d{2}\/\d{2})\)/
    parse_date($1) if $1
  end

  def parse_sold_price
    @data =~ /Sold: US\$.(\d+,?\d+,?\d+)/
    $1.gsub(',','').to_i if $1
  end

  def parse_listed_price
    @data =~ /Last Listed Price: US\$.(\d+,?\d+,?\d+)/
    $1.gsub(',','').to_i if $1
  end

  def parse_year_of_boat
    @data =~ /Year: (\d+)</
    $1.to_i if $1
  end

  def parse_length
    @data =~ /<h3>(\d+)'/
    $1.to_i if $1
  end

  def parse_date(str)
    Date.strptime(str, DATE_FORMAT)
  end

end
