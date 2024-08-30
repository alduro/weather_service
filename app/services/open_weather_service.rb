# app/services/weather_service.rb
require "httparty"

class OpenWeatherService
  include HTTParty
  base_uri "https://api.openweathermap.org/data/2.5"

  def initialize(api_key)
    @api_key = api_key
  end

  def current_weather(lat:, lon:)
    response = self.class.get("/weather", query: { lat: lat, lon: lon, appid: @api_key, units: "imperial" })
    handle_response(response)
  end

  def weather_by_city(city_name:)
    response = self.class.get("/weather", query: { q: city_name, appid: @api_key, units: "imperial" })
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      response
    else
      { "error" => response["message"] || "Unknown error" }
    end
  end
end
