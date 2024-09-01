
require 'net/http'
require 'json'

class WeatherService
  API_KEY = 'nATNfkzGnSFfxZDM1k55L4WMOvTPYTUM'
  BASE_URL = 'http://dataservice.accuweather.com/'
  LOCATION_KEY = '295863'
  city = 'Kazan'
  CITY = 'Kazan'


  def self.fetch_and_store_weather_data

    url = URI("#{BASE_URL}currentconditions/v1/#{LOCATION_KEY}?apikey=#{API_KEY}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response).first

    WeatherData.create!(
      city: city,
      timestamp: data['LocalObservationDateTime'],
      temperature: data['Temperature']['Metric']['Value']
    )
  end

  def self.get_current_weather
    url = URI("#{BASE_URL}currentconditions/v1/#{LOCATION_KEY}?apikey=#{API_KEY}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response).first

    # Возвращаем данные в формате JSON
    {
      city: CITY,
      timestamp: data['LocalObservationDateTime'],
      temperature: data['Temperature']['Metric']['Value'],
      weather: data['WeatherText']
    }
  rescue => e
    # Обработка ошибок, если что-то пойдет не так
    { error: e.message }
  end

  def self.get_historical_weather
    WeatherData.where('timestamp > ?', 24.hours.ago).order(:timestamp)
  end

  def self.get_max_temperature
    get_historical_weather.maximum(:temperature)
  end

  def self.get_min_temperature
    get_historical_weather.minimum(:temperature)
  end

  def self.get_avg_temperature
    get_historical_weather.average(:temperature)
  end

  def self.get_temperature_by_timestamp(requested_timestamp)
    nearest_time = WeatherData.where('timestamp <= ?', Time.at(requested_timestamp))
                              .order(timestamp: :desc)
                              .first

    raise ActiveRecord::RecordNotFound unless nearest_time

    nearest_time
  end

end
