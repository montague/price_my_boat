module MachineLearningUtilities
  def training_set_and_test_set_for(data, test_percentage=0.05)
    training_set, test_set = [], []
    data.each do |datum|
      if rand < test_percentage
        test_set << datum
      else
        training_set << datum
      end
    end
    test_set << training_set.pop if test_set.empty?
    return training_set, test_set
  end

  def evaluate_algorithm(algorithm, training_set, test_set)
    error = 0.0
    test_set.each do |datum|
      guess = if algorithm.respond_to?(:call)
                algorithm.call(datum[:attributes], training_set)
              else
                send(algorithm, datum[:attributes], training_set)
              end
      error += (datum[:value] - guess) ** 2
    end
    error / test_set.length
  end

  def cross_validate(algorithm, data, trials: 100, test_percentage: 0.05)
    error = 0.0
    trials.times do
      training_set, test_set = training_set_and_test_set_for(data, test_percentage)
      error += evaluate_algorithm(algorithm, training_set, test_set)
    end
    error / trials
  end
end
