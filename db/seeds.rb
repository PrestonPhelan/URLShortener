# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create(:email => "user1@gmail.com")
user2 = User.create(:email => "user2@gmail.com")

surl1 = ShortenedUrl.create(:long_url => "www.longurl.com", :short_url => "www.shorturl.com", :user_id => 1)
