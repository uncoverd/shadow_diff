class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.string :request_id
      t.string :url
      t.text :production
      t.text :shadow
      t.integer :commit_id
      t.datetime :time
      t.float :score

      t.timestamps
    end
  end
end
