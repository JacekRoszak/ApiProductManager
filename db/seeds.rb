# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create([{ name: 'prod1', code: 'prod1code', quantity: 11 },
                { name: 'prod2', code: 'prod2code', quantity: 12 },
                { name: 'prod3', code: 'prod3code', quantity: 13 },
                { name: 'prod4', code: 'prod4code', quantity: 14 }])

User.create([{ login: 'user1', password_digest: 'password', admin: true },
             { login: 'user2', password_digest: 'password', admin: false },
             { login: 'user3', password_digest: 'password', admin: false },
             { login: 'user4', password_digest: 'password', admin: false }])

Order.create(user_id: User.first.id, code: Product.first.code, quantity: 1)
