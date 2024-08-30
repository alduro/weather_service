# spec/models/weather_spec.rb
require 'rails_helper'

RSpec.describe Weather, type: :model do
  describe '.cached_by_coordinates?' do
    let(:lat) { 40.7128 }
    let(:lon) { -74.0060 }
    let!(:weather) { create(:weather, lat: lat, lon: lon, cached_at: 30.minutes.ago) }

    it 'returns true if weather data is cached and valid' do
      expect(Weather.cached_by_coordinates?(lat, lon)).to be true
    end

    it 'returns false if weather data is not cached' do
      expect(Weather.cached_by_coordinates?(0, 0)).to be false
    end

    it 'returns false if cached data is expired' do
      weather.update(cached_at: 2.hours.ago)
      expect(Weather.cached_by_coordinates?(lat, lon)).to be false
    end
  end

  describe '.fetch_weather' do
    let(:lat) { 40.7128 }
    let(:lon) { -74.0060 }

    context 'when weather data is cached' do
      let!(:weather) { create(:weather, lat: lat, lon: lon, cached_at: 30.minutes.ago) }

      it 'returns the cached weather data' do
        expect(Weather.fetch_weather(lat: lat, lon: lon)).to eq(weather)
      end
    end

    context 'when weather data is not cached' do
      before do
        allow_any_instance_of(OpenWeatherService).to receive(:current_weather).and_return({
          'name' => 'New York',
          'main' => { 'temp' => 75.0 },
          'weather' => [ { 'description' => 'clear sky' } ]
        })
      end

      it 'fetches new weather data from the API and caches it' do
        new_weather = Weather.fetch_weather(lat: lat, lon: lon)
        expect(new_weather.city).to eq('New York')
        expect(new_weather.temperature).to eq(75.0)
        expect(new_weather.weather_description).to eq('clear sky')
      end
    end
  end
end
