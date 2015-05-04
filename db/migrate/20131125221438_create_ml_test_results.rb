class CreateMlTestResults < ActiveRecord::Migration
  def change
    create_table :ml_test_results do |t|
      t.string :algorithm, :null => false
      t.hstore :config, :null => false
      t.timestamps
    end
  end
end
