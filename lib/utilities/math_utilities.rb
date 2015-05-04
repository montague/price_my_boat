module MathUtilities
  def euclidean_distance(v1,v2)
    raise "can't compute distance between mismatched vectors" unless v1.length == v2.length
    accumulator = 0.0
    v1.each_with_index do |_, idx|
      accumulator += (v1[idx] - v2[idx]) ** 2
    end
    Math.sqrt(accumulator)
  end

  def distances_from(vector, data)
    # expects an array of hashes
    # eg [
    #       {value: 100, attributes: [1,2,3]},
    #       {value: 200, attributes: [2,3,4]}
    #    ]
    # returns a list of distances and indices into the data
    # sorted by distances
    # eg [ [2.0, 12], [3.1, 2] ]
    data.map.with_index do |datum, idx|
      [euclidean_distance(vector, datum[:attributes]), idx]
    end.sort
  end

  def rescale(data, scale)
    data.map.with_index do |datum, i|
      attrs = datum[:attributes]
      {
        value: datum[:value],
        attributes: scale.length.times.map do |j|
          attrs[j] * scale[j]
        end
      }
    end
  end

  def knn(vector, data, k: 3)
    distances = distances_from(vector, data)
    average = 0.0
    k.times do |i|
      index = distances[i][1]
      average += data[index][:value]
    end
    average / k
  end

  def knn_weighted(vector, data, k: 3, weight_fn: :gaussian)
    distances = distances_from(vector, data)
    average, total_weight = 0.0, 0.0
    k.times do |i|
      index = distances[i][1]
      weight = Weight.send(weight_fn, distances[i][0])
      average += (weight * data[index][:value])
      total_weight += weight
    end
    average / total_weight
  end

  class Weight
    # picked an arbitrary tiny number
    MIN = BigDecimal.new("0.000000000000000000000001")

    class << self
      def gaussian(distance, sigma: 1.0)
        weight = Math::E ** (-((distance ** 2.0) / (2.0 * sigma ** 2.0)))
        if weight.zero?
          weight = MIN
        end
        weight
      end

      def inverse(distance, n: 1.0, constant: 0.1)
        n / (distance + constant)
      end

      def subtraction(distance, constant: 1.0)
        return 0 if distance > constant
        constant - distance
      end
    end
  end
end
