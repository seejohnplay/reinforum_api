class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :author
      t.references :category, foreign_key: true
      t.integer :vote_score, default: 0
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
