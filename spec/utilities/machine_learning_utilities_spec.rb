require 'spec_helper'

describe MachineLearningUtilities do
  class Dummy
    include MachineLearningUtilities

    def simple_algorithm(data, query)
      data.first
    end
  end

  before :each do
    @dummy = Dummy.new
  end

  describe '#test_set_and_training_set_for' do
    it "returns a training set and a smaller test set" do
      data = (1..10).to_a
      training_set, test_set = @dummy.training_set_and_test_set_for(data)

      expect(training_set.length).to be > test_set.length
    end
  end

  describe "#evaluate_algorithm" do
    it "returns an average error rate for a particular algorithm" do
      test_set = [{value: 1, attributes: [2]}]
      training_set = []
      average_error = @dummy.evaluate_algorithm(:simple_algorithm, training_set, test_set)

      expect(average_error).to eq 1.0
    end
  end

  describe '#crossvalidate' do
    it "returns an average algorithm error rate over multiple evaluations" do
      trials = 10
      @dummy.stub(:evaluate_algorithm).and_return(2)

      expect(@dummy.cross_validate(:simple_algorithm, [], trials: trials)).to eq 2
    end

    it "runs k trials to validate an algorithm" do
      k = 4
      data = [
        {value: 1, attributes: [1]},
        {value: 1, attributes: [2]},
        {value: 3, attributes: [4]}
      ]
      expect(@dummy).to receive(:evaluate_algorithm).and_call_original.exactly(k).times

      @dummy.cross_validate(:simple_algorithm, data, trials: k)
    end
  end
end
