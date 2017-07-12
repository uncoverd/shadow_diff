class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :commit, index: true, foreign_key: true
      t.references :url, index: true, foreign_key: true
      t.string :request_id
      t.text :production
      t.text :shadow
      t.integer :commit_id
      t.datetime :time
      t.float :score
      t.text :production_request
      t.text :shadow_request
      t.string :verb
      t.timestamps
    end
  end
end
