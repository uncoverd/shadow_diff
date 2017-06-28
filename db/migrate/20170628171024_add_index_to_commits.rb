class AddIndexToCommits < ActiveRecord::Migration[5.0]
  def change
    add_index :commits, :commit_hash, unique: true
  end
end
