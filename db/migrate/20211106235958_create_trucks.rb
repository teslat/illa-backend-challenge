class CreateTrucks < ActiveRecord::Migration[6.1]
  def change
    create_table :trucks do |t|
      t.string :plate_number
      t.timestamps
    end
  end
end
