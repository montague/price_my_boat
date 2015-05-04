class BoatListing < ActiveRecord::Base
  validates :yw_id, :presence => true

  scope :most_recent, -> {where.not(:date_sold => nil).order('date_sold desc')}
end
