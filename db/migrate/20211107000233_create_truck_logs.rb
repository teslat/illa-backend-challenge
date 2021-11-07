class CreateTruckLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :truck_logs do |t|
      t.references :truck
      t.decimal :latitude, precision:10, scale: 6
      t.decimal :longitude, precision:10, scale:6
      t.st_point :geom, geographic: true
      t.timestamps
    end
  end
end
