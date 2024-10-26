# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.references :source_user, null: false, foreign_key: { to_table: :users }
      t.references :target_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
