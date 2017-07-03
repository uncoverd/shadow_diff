class CreateRules < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.float :modifier
      t.string :name
      t.string :regex_string
      t.references :url, foreign_key: true
      t.references :commit, foreign_key: true
      t.integer :status
      t.integer :action
      t.timestamps
    end
  end
end
