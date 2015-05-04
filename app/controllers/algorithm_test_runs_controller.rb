class AlgorithmTestRunsController < ApplicationController
  def new
    @test_run = AlgorithmTestRun.new
  end

  def create
    @test_run = AlgorithmTestRun.new(test_run_params)
    config = {
        k: test_run_params[:k],
        data_size: 3000,
        trials: 20,
        test_percentage: 0.05,
        scale: BoatListingAdapter.scale_vector
    }
    @test_run.config = config
    adapter = BoatListingAdapter.new(BoatListing.most_recent.limit(config[:data_size]))
    data = valuator.rescale(adapter.training_set, config[:scale])
    if @test_run.valid_for_test_run?
      @test_run.run_test_and_save_results_for(data)
      render :json => @test_run.to_abbreviated_json_hash
    else
      render :json => {:error => 'bad'}, :status => :unprocessable_entity
    end
  end

  private
  def test_run_params
    params.require(:algorithm_test_run).permit(:algorithm, :k)
  end
end
