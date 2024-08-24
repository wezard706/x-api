# == Schema Information
#
# Table name: author_books
#
#  id         :bigint           not null, primary key
#  author_id  :bigint           not null
#  book_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AuthorBook < ApplicationRecord
  belongs_to :book
  belongs_to :author
end
