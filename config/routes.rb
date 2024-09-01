Rails.application.routes.draw do
  mount WeatherApi::Base => '/'
end
