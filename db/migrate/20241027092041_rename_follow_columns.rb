# frozen_string_literal: true

class RenameFollowColumns < ActiveRecord::Migration[7.1]
  def change
    change_table :follows, bulk: true do |t|
      t.rename :source_user_id, :follower_id
      t.rename :target_user_id, :followed_id
    end
  end
end
