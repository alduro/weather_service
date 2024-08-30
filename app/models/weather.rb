# app/models/weather.rb
class Weather < ApplicationRecord
  CACHE_DURATION = 1.hour

  def self.cached_by_city?(city_name)
    where("lower(city) = ?", city_name.downcase).where("cached_at > ?", CACHE_DURATION.ago).exists?
  end

  def self.cached_by_coordinates?(lat, lon)
    where(lat: lat, lon: lon).where("cached_at > ?", CACHE_DURATION.ago).exists?
  end

  def self.fetch_weather(lat:, lon:)
    if cached_by_coordinates?(lat, lon)
      where(lat: lat, lon: lon).order(cached_at: :desc).first
    else
      service = OpenWeatherService.new(ENV["OPENWEATHER_API_KEY"])
      response = service.current_weather(lat: lat, lon: lon)
      if response["error"]
        { error: response["error"] }
      else
        create(
          city: response["name"],
          lat: lat,
          lon: lon,
          temperature: response["main"]["temp"],
          weather_description: response["weather"][0]["description"],
          cached_at: Time.current
        )
      end
    end
  end

  def self.fetch_weather_by_city(city_name:)
    if cached_by_city?(city_name)
      where(city: city_name).order(cached_at: :desc).first
    else
      service = OpenWeatherService.new(ENV["OPENWEATHER_API_KEY"])
      response = service.weather_by_city(city_name: city_name)
      if response["error"]
          { error: response["error"] }
      else
        create(
          city: response["name"],
          state: response["sys"]["country"],
          lat: response["coord"]["lat"],
          lon: response["coord"]["lon"],
          temperature: response["main"]["temp"],
          weather_description: response["weather"][0]["description"],
          cached_at: Time.current
        )
      end
    end
  end
end
