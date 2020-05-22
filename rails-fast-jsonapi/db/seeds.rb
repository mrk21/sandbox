# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

author1 = Author.create!(name: 'author 1')
author2 = Author.create!(name: 'author 2')

article1 = Article.create!(title: 'article 1', body: 'article 1 body', author: author1)
article2 = Article.create!(title: 'article 2', body: 'article 2 body', author: author1)
article3 = Article.create!(title: 'article 3', body: 'article 3 body', author: author2)
