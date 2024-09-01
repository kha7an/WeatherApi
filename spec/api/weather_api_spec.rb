require 'rails_helper'

RSpec.describe WeatherApi::Base, type: :request do
  describe 'GET /api/weather/current' do
    it 'returns current temperature' do
      weather_data = WeatherData.create(city: 'Kazan', timestamp: Time.now, temperature: 15.5)

      get '/api/weather/current'

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('temperature')
      expect(json_response['temperature']).to eq(weather_data.temperature)
    end
  end

  describe 'GET /api/weather/historical' do
    it 'returns historical temperatures for the last 24 hours' do
      weather_data1 = WeatherData.create(city: 'Kazan', timestamp: 2.hours.ago, temperature: 14.0)
      weather_data2 = WeatherData.create(city: 'Kazan', timestamp: 1.hour.ago, temperature: 15.0)

      get '/api/weather/historical'

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first['temperature']).to eq(weather_data1.temperature)
      expect(json_response.second['temperature']).to eq(weather_data2.temperature)
    end
  end

  describe 'GET /api/weather/historical/max' do
    it 'returns maximum temperature for the last 24 hours' do
      WeatherData.create(city: 'Kazan', timestamp: 2.hours.ago, temperature: 14.0)
      WeatherData.create(city: 'Kazan', timestamp: 1.hour.ago, temperature: 15.0)

      get '/api/weather/historical/max'

      expect(response).to have_http_status(200)
      expect(response.body.to_f).to eq(15.0)
    end
  end

  describe 'GET /api/weather/historical/min' do
    it 'returns minimum temperature for the last 24 hours' do
      WeatherData.create(city: 'Kazan', timestamp: 2.hours.ago, temperature: 14.0)
      WeatherData.create(city: 'Kazan', timestamp: 1.hour.ago, temperature: 15.0)

      get '/api/weather/historical/min'

      expect(response).to have_http_status(200)
      expect(response.body.to_f).to eq(14.0)
    end
  end

  describe 'GET /api/weather/historical/avg' do
    it 'returns average temperature for the last 24 hours' do
      WeatherData.create(city: 'Kazan', timestamp: 2.hours.ago, temperature: 14.0)
      WeatherData.create(city: 'Kazan', timestamp: 1.hour.ago, temperature: 16.0)

      get '/api/weather/historical/avg'

      expect(response).to have_http_status(200)
      expect(response.body.to_f).to eq(15.0)
    end
  end

  describe 'GET /api/weather/by_time' do
    it 'returns temperature closest to the provided timestamp' do
      target_time = Time.now
      WeatherData.create(city: 'Kazan', timestamp: target_time - 1.hour, temperature: 14.0)
      closest_data = WeatherData.create(city: 'Kazan', timestamp: target_time - 10.minutes, temperature: 15.0)

      get "/api/weather/by_time?timestamp=#{target_time.to_i}"

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['temperature']).to eq(closest_data.temperature)
    end

    it 'returns 404 if no temperature data is found' do
      get "/api/weather/by_time?timestamp=#{Time.now.to_i}"

      expect(response).to have_http_status(404)
    end
  end

  describe 'GET /api/health' do
    it 'returns backend status' do
      get '/api/health'

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('OK')
    end
  end
end
