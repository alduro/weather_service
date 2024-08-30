# app/controllers/weather_controller.rb
class WeatherController < ApplicationController
  def index
    @weather = if params[:lat].present? && params[:lon].present?
                 Weather.fetch_weather(lat: params[:lat], lon: params[:lon])
    elsif params[:city].present?
                 Weather.fetch_weather_by_city(city_name: params[:city])
    else
      @weather = nil
    end

    respond_to do |format|
      if @weather.is_a?(Hash) && @weather[:error]
        format.html { render :index, alert: @weather[:error] }
        format.json { render json: { error: @weather[:error] }, status: :unprocessable_entity }
      else
        format.html # index.html.erb
        format.json { render json: @weather }
      end
    end
  end

  def show
    @weather = Weather.find(params[:id])
  end
end
