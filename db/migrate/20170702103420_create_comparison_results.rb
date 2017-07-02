class CreateComparisonResults < ActiveRecord::Migration[5.0]
  def change
    create_table :comparison_results do |t|
      t.references :response, foreign_key: true
      t.references :rule, foreign_key: true
      t.integer :index
      t.float :line_score
      t.timestamps
    end
  end
end
