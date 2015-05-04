class AddErrorMetricToAlgorithmTestRun < ActiveRecord::Migration
  def change
    add_column :algorithm_test_runs, :error_metric, :integer, :null => false
  end
end
