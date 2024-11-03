# frozen_string_literal: true

class AddUniqueIndexToFollows < ActiveRecord::Migration[7.1]
  def change
    change_table :follows, bulk: true do |t|
      t.index %i[followed_id follower_id], unique: true
      t.index %i[follower_id followed_id], unique: true
    end
  end
end
