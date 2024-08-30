# spec/factories/weather.rb
FactoryBot.define do
  factory :weather do
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    temperature { Faker::Number.between(from: -30.0, to: 120.0) }
    weather_description { Faker::Lorem.sentence }
    cached_at { Time.current }
  end
end
