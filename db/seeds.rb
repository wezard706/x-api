# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
seeds = [
  {
    title: "羅生門",
    description: "大正期に活躍した「新思潮派」の作家、芥川竜之介の代表的な短編小説。",
    price: 0,
    publisher: "集英社",
    published_at: "2012/9/27",
    author: "芥川 龍之介"
  },
  {
    title: "白夜行",
    description: "1973年、大阪の廃墟ビルで一人の質屋が殺された。",
    price: 1430,
    publisher: "集英社",
    published_at: "2002/5/25",
    author: "東野 圭吾"
  },
  {
    title: "コンビニ人間",
    description: "「普通」とは何か？現代の実存を軽やかに問う第155回芥川賞受賞作",
    price: 631,
    publisher: "文春文庫",
    published_at: "2018/9/4",
    author: "村田 沙耶香"
  },
]

seeds.each do |seed|
  publisher = Publisher.find_or_create_by!(name: seed[:publisher])
  author = Author.find_or_create_by!(name: seed[:author])
  book = Book.find_or_create_by!(
    title: seed[:title],
    description: seed[:description],
    price: seed[:price],
    publisher:,
    published_at: seed[:published_at],
    )
  AuthorBook.find_or_create_by!(author:, book:)
end