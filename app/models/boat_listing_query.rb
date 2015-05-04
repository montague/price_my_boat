class BoatListingQuery
  include ActiveAttr::BasicModel
  EXPECTED_ATTRS = BoatListingAdapter::ATTRS_AND_SCALE.keys

  attr_accessor *(EXPECTED_ATTRS + [:sold_price])

  def initialize(params={})
    # want to be able to have nil as valid values
    EXPECTED_ATTRS.each do |attr|
      instance_variable_set("@#{attr}", params[attr] && params[attr].to_i)
    end
  end

  def valid?
    EXPECTED_ATTRS.each do |attr|
      value = send("#{attr}")
      return false if value.nil? || value.zero?
    end
    true
  end
end
