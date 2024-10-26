# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  source_user_id :bigint           not null
#  target_user_id :bigint           not null
#
# Indexes
#
#  index_follows_on_source_user_id  (source_user_id)
#  index_follows_on_target_user_id  (target_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_user_id => users.id)
#  fk_rails_...  (target_user_id => users.id)
#
class Follow < ApplicationRecord
  belongs_to :source_user, class_name: 'User'
  belongs_to :target_user, class_name: 'User'
end
