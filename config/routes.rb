Rails.application.routes.draw do
  get "weather/index"
  get "weather", to: "weather#index"
end
