# == Schema Information
#
# Table name: books
#
#  id           :bigint           not null, primary key
#  description  :string(255)
#  price        :integer          not null
#  published_at :date
#  title        :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  publisher_id :bigint           not null
#
# Indexes
#
#  index_books_on_publisher_id  (publisher_id)
#
# Foreign Keys
#
#  fk_rails_...  (publisher_id => publishers.id)
#
class Book < ApplicationRecord
  belongs_to :publisher
  has_many :author_books
  has_many :authors, through: :author_books

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :publisher, presence: true
  validates :published_at, presence: true
end
