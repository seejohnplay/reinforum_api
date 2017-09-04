class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :post, foreign_key: true
      t.text :body
      t.string :author
      t.integer :vote_score, default: 0
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
