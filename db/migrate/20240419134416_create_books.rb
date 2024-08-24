class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :description
      t.integer :price, null: false
      t.references :publisher, null: false, foreign_key: true
      t.date :published_at

      t.timestamps
    end
  end
end
