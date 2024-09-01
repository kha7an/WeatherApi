module WeatherApi
  class Base < Grape::API
    prefix 'api'
    format :json

    resource :weather do
      desc 'Get current temperature'
      get :current do
        result = WeatherService.get_current_weather
        result
      end

      desc 'Get historical temperatures for the last 24 hours'
      get :historical do
        WeatherService.get_historical_weather
      end

      desc 'Get maximum temperature for the last 24 hours'
      get 'historical/max' do
        WeatherService.get_max_temperature
      end

      desc 'Get minimum temperature for the last 24 hours'
      get 'historical/min' do
        WeatherService.get_min_temperature
      end

      desc 'Get average temperature for the last 24 hours'
      get 'historical/avg' do
        WeatherService.get_avg_temperature
      end

      desc 'Get temperature closest to the provided timestamp'
      params do
        requires :timestamp, type: Integer, desc: 'Timestamp in seconds'
      end
      get 'by_time' do
        WeatherService.get_temperature_by_timestamp(params[:timestamp])
      end
    end

    resource :health do
      desc 'Get backend status'
      get do
        { status: 'OK' }
      end
    end
  end
end
