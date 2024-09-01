require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  describe '.fetch_and_store_weather_data' do
    it 'fetches and stores weather data' do
      allow(Net::HTTP).to receive(:get).and_return(
        '[{"LocalObservationDateTime": "2023-01-01T12:00:00+00:00", "Temperature": {"Metric": {"Value": 15.0}}}]'
      )

      expect {
        WeatherService.fetch_and_store_weather_data
      }.to change { WeatherData.count }.by(1)

      weather_data = WeatherData.last
      expect(weather_data.city).to eq('Kazan')
      expect(weather_data.temperature).to eq(15.0)
    end
  end

  describe '.get_current_weather' do
    it 'returns the most recent weather data' do
      old_data = WeatherData.create(city: 'Kazan', timestamp: 1.hour.ago, temperature: 14.0)
      new_data = WeatherData.create(city: 'Kazan', timestamp: Time.now, temperature: 15.0)

      result = WeatherService.get_current_weather

      expect(result).to eq(new_data)
    end
  end
end