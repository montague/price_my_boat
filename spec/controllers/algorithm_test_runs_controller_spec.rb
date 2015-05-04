require 'spec_helper'

describe AlgorithmTestRunsController do
  describe 'new' do
    it 'should render successfully' do
      get :new

      expect(response).to be_success
    end
  end

  describe 'create' do
    context 'success' do
      before do
        Valuator.instance.should_receive(:cross_validate).and_return(1212)
      end

      it 'renders successfully' do
        post :create, :algorithm_test_run => {:algorithm => :knn}

        expect(response).to be_success
      end

      it 'creates a new test run object' do
        expect {
          post :create, :algorithm_test_run => {:algorithm => :knn}
        }.to change { AlgorithmTestRun.count }.by 1
      end
    end

    context 'failure' do
      it 'returns unprocessable_entity' do
        post :create, :algorithm_test_run => {:algorithm => :omg}

        expect(response.status).to eq 422
      end

      it 'does not create a new test run object' do
        expect{
          post :create, :algorithm_test_run => {:algorithm => :lol}
        }.to_not change { AlgorithmTestRun.count }
      end
    end
  end
end