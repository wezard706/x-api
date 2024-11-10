# frozen_string_literal: true

class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.text :content, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
