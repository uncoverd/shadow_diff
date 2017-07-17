class AddMetricsToResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :responses, :shadow_sql_requests, :float
    add_column :responses, :production_sql_requests, :float
    add_column :responses, :shadow_view_runtime, :float
    add_column :responses, :production_view_runtime, :float
    add_column :responses, :shadow_db_runtime, :float
    add_column :responses, :production_db_runtime, :float
  end
end
