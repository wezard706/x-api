# == Schema Information
#
# Table name: publishers
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Publisher < ApplicationRecord
  has_many :books

  validates :name, presence: true
end
