class Valuator
  include Singleton
  include MathUtilities
  include MachineLearningUtilities

  def value_for(new_listing, k: 3)
    query = adapter.query_for(new_listing)
    #knn_weighted(query, training_set, k: k)
    knn(query, training_set, k: k)
  end

  def adapter
    @adapter ||= BoatListingAdapter.new(BoatListing.all)
  end

  def training_set(rescale: false)
    # data is an array of hashes of attrs
    @training_set ||= if rescale
                        rescale(adapter.training_set, BoatListingAdapter.scale_vector)
                      else
                        adapter.training_set
                      end
  end
end
