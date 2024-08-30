# spec/services/weather_service_spec.rb
require 'rails_helper'

RSpec.describe OpenWeatherService do
  let(:api_key) { 'test_api_key' }
  let(:service) { OpenWeatherService.new(api_key) }

  describe '#current_weather' do
    it 'makes a request to the OpenWeatherMap API' do
      stub_request(:get, "https://api.openweathermap.org/data/2.5/weather")
        .with(query: hash_including(lat: '40.7128', lon: '-74.0060', appid: api_key))
        .to_return(status: 200, body: { "main" => { "temp" => 75.0 }, "name" => "New York", "weather" => [ { "description" => "clear sky" } ] }.to_json)

      response = service.current_weather(lat: 40.7128, lon: -74.0060)
      expect(response['name']).to eq('New York')
      expect(response['main']['temp']).to eq(75.0)
      expect(response['weather'][0]['description']).to eq('clear sky')
    end
  end

  describe '#weather_by_city' do
    it 'fetches weather data by city name' do
      stub_request(:get, "https://api.openweathermap.org/data/2.5/weather")
        .with(query: hash_including(q: 'New York', appid: api_key))
        .to_return(status: 200, body: { "main" => { "temp" => 75.0 }, "name" => "New York", "weather" => [ { "description" => "clear sky" } ] }.to_json)

      response = service.weather_by_city(city_name: 'New York')
      expect(response['name']).to eq('New York')
      expect(response['main']['temp']).to eq(75.0)
      expect(response['weather'][0]['description']).to eq('clear sky')
    end
  end
end
