require 'spec_helper'

describe BoatListingQueriesController do
  describe 'new' do
    it 'renders successfully' do
      get :new

      expect(response).to be_success
    end
  end

  describe 'create' do
    context 'success' do
      it 'renders successfully' do
        post :create, :boat_listing_query => {
            :length => 50,
            :year_of_boat => 2012,
            :listed_price => 600000
        }

        expect(response).to be_success
        expect(response).to render_template 'boat_listing_queries/query_result'
      end
    end

    context 'failure' do
      it 'returns unprocessable entity' do
        post :create, :boat_listing_query => {
            :length => :omg
        }

        expect(response.status).to eq 422
      end
    end
  end

end
