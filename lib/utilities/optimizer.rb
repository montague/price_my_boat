class Optimizer
  extend MathUtilities
  extend MachineLearningUtilities

  def self.create_cost_function(algorithm, data)
    ->(scale) {
      scaled_data = rescale(data, scale)
      cross_validate(algorithm, scaled_data, trials: 10)
    }
  end

  def self.annealing_optimize(domain, cost_function,
                         temp: 10000.0, cool: 0.95, step: 1)
    # domain is an array of ranges [(min..max)] * length of vector
    # initialize the values randomly (but stay within the domain)
    vector = domain.map {|min_max_range| rand(min_max_range)}
    vector_cost = cost_function.call(vector)
    while temp > 0.1
      # rondomly choose an index to adjust
      index = rand(vector.length - 1)
      # choose a delta to apply to that element in the vector
      delta = rand(-step..step)

      # create a new vector with the element at the
      # selected index changed by the direction
      changed_vector = vector.dup
      changed_vector[index] += delta

      # reconcile if new value is below domain min
      # or above domain max
      if changed_vector[index] < domain[index].min
        changed_vector[index] = domain[index].min
      elsif
        changed_vector[index] > domain[index].max
        changed_vector[index] = domain[index].max
      end

      # calculate current cost and new cost
      #vector_cost = cost_function.call(vector)
      changed_vector_cost = cost_function.call(changed_vector)
      exponent = (-changed_vector_cost - vector_cost) / temp
      probability_of_accepting_higher_cost_soln = Math::E ** exponent

      # is it better, or does it make the probabbility cutoff?
      if (changed_vector_cost < vector_cost) || (rand < probability_of_accepting_higher_cost_soln)
        vector = changed_vector
        vector_cost = changed_vector_cost
      end

      # decrease the temp
      temp *= cool
      puts "===> temp now at #{temp}"
    end
    vector
  end
end
