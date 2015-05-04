class BoatListingQueriesController < ApplicationController
  def new
    @query = BoatListingQuery.new
  end


  def create
    @query = BoatListingQuery.new(query_params)
    if @query.valid?
      @query.sold_price = valuator.value_for(@query).round
      render 'boat_listing_queries/query_result', :layout => false
    else
      render :text => '<h2>All values are required and must be numbers</h2>', :status => :unprocessable_entity
    end
  end

  private
  def query_params
    allowed = %i(length year_of_boat listed_price)
    params.require(:boat_listing_query).permit(*allowed)
  end
end
