class CreateCommits < ActiveRecord::Migration[5.0]
  def change
    create_table :commits do |t|
      t.float :score
      t.string :description
      t.string :commit_hash
      t.string :commit_url

      t.timestamps
    end
  end
end
