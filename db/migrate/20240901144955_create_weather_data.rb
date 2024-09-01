class CreateWeatherData < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_data do |t|
      t.string :city
      t.datetime :timestamp
      t.float :temperature

      t.timestamps
    end
  end
end
