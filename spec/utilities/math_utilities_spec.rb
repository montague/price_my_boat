require 'spec_helper'

describe MathUtilities do
  class Dummy; include MathUtilities; end
  before :all do
    @dummy = Dummy.new
  end

  describe '#euclidean_distance' do
    it 'returns the euclidean distance between two vectors' do
      distance = @dummy.euclidean_distance([1,2,3,4], [2,3,4,5])

      expect(distance).to eq 2
    end

    it 'raises if vectors are different sizes' do
      expect {
        @dummy.euclidean_distance([],[1])
      }.to raise_error
    end
  end

  describe '#distances_from' do
    it 'returns distances and indexes for a vector and data set' do
      vector = [1,2,3,4]
      data = [
        {value: 12, attributes: [3,4,5,6]},
        {value: 24, attributes: [2,3,4,5]}
      ]
      expected_distances = [ [2.0,1], [4.0,0] ]
      distances = @dummy.distances_from(vector, data)

      expect(distances).to match_array expected_distances
    end
  end

  describe '#rescale_data' do
    it 'returns scaled data' do
      data = [
        {value: 1, attributes: [1,2,3]},
        {value: 2, attributes: [2,3,4]}
      ]
      scale = [2,3,4]
      expected_data = [
        {value: 1, attributes: [2,6,12]},
        {value: 2, attributes: [4,9,16]}
      ]

      expect(@dummy.rescale(data, scale)).to match_array expected_data
    end
  end

  describe "#knn" do
    it "returns the average of nearest neighbors" do
      vector = [1,2,3,4]
      data = [
        {value: 2, attributes: [1,2,3,4]},
        {value: 4, attributes: [2,3,4,5]},
        {value: 10, attributes: [9,10,11,23]}
      ]
      estimate = @dummy.knn(vector, data, k: 2)

      expect(estimate).to eq 3.0
    end
  end

  describe '#knn_weighted' do
    it "returns the weighted average of nearest neighbors" do
      vector = [1,2,3,4]
      data = [
        {value: 2, attributes: [1,2,3,4]},
        {value: 4, attributes: [2,3,4,5]},
        {value: 10, attributes: [9,10,11,23]}
      ]
      estimate = @dummy.knn_weighted(vector, data, k: 2, weight_fn: :gaussian)

      expect(estimate).to eq 2.2384058440442347
    end
  end

  context "Weight" do
    describe ".gaussian" do
      it "returns the right value" do
        expect(Dummy::Weight.gaussian(4)).to eq 0.00033546262790251196
      end

      it "returns MIN instead of zero" do
        expect(Dummy::Weight.gaussian(100)).to eq Dummy::Weight::MIN
      end
    end

    describe '.inverse' do
      it 'returns the right value' do
        expect(Dummy::Weight.inverse(0.9)).to eq 1.0
      end
    end

    describe '.subtraction' do
      it "can return a zero weight" do
        expect(Dummy::Weight.subtraction(1.1)).to eq 0
      end

      it "returns the right value" do
        expect(Dummy::Weight.subtraction(0.8)).to be_within(0.001).of(0.2)
      end
    end
  end
end
