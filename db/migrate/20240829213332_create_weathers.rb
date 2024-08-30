class CreateWeathers < ActiveRecord::Migration[7.2]
  def change
    create_table :weathers do |t|
      t.string :city
      t.string :state
      t.float :lat
      t.float :lon
      t.float :temperature
      t.string :weather_description
      t.datetime :cached_at

      t.timestamps
    end
  end
end
