require "faker"

users = 20.times.map { User.create!(name: Faker::Name.name) }

users.each do |user|
  rand(1..15).times do
    Order.create!(
      user: user,
      total: rand(10..200),
      created_at: rand(60).days.ago
    )
  end
end
