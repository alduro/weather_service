# spec/controllers/weather_controller_spec.rb
require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe 'GET #index' do
    context 'with lat and lon parameters' do
      let(:lat) { 40.7128 }
      let(:lon) { -74.0060 }
      let!(:weather) { create(:weather, lat: lat, lon: lon, cached_at: 30.minutes.ago) }

      it 'assigns the requested weather as @weather' do
        get :index, params: { lat: lat, lon: lon }
        expect(assigns(:weather)).to eq(weather)
      end
    end

    context 'with city parameter' do
      let(:city) { 'New York' }
      let(:weather) { create(:weather, city: city, cached_at: 30.minutes.ago) }

      before do
        allow(Weather).to receive(:fetch_weather_by_city).with(city_name: city).and_return(weather)
      end

      it 'assigns the requested weather by city as @weather' do
        get :index, params: { city: city }
        expect(assigns(:weather)).to eq(weather)
      end
    end
  end
end
