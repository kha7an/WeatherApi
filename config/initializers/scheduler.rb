require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
  WeatherService.fetch_and_store_weather_data
end
