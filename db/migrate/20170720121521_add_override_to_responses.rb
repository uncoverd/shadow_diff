class AddOverrideToResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :responses, :override, :boolean
  end
end
