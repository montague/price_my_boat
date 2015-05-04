class AlgorithmTestRun < ActiveRecord::Base
  include MathUtilities
  include MachineLearningUtilities

  ALGORITHMS = %w(knn knn_weighted)
  validates :algorithm, :presence => true, :inclusion => {:in => ALGORITHMS}
  validates :config, :presence => true

  scope :the_winner, -> { order('error_metric').first }

  attr_accessor :k

  # start out supporting knn
  def run_test_and_save_results_for(data)
    fn = -> (query, training_set) {
      send(algorithm, query, training_set, k: config[:k].to_i)
    }
    self.error_metric = cross_validate(
        fn, data, trials: config[:trials],
        test_percentage: config[:test_percentage]
    )
    save!
  end

  def to_abbreviated_json_hash
    {
        :algorithm => algorithm,
        :config => config,
        :error_metric => error_metric
    }
  end

  def valid_for_test_run?
    return false if self.algorithm.blank?
    return false if self.config.values.empty?
    true
  end
end
