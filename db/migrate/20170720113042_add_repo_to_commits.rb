class AddRepoToCommits < ActiveRecord::Migration[5.0]
  def change
    add_column :commits, :repo, :string
  end
end
