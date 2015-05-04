class ChangeToAlgorithmTestRun < ActiveRecord::Migration
  def up
    rename_table :ml_test_results, :algorithm_test_runs
  end

  def down
    rename_table :algorithm_test_runs, :ml_test_results
  end
end
