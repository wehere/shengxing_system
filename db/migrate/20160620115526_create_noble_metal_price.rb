class CreateNobleMetalPrice < ActiveRecord::Migration
  def change
    create_table :noble_metal_prices do |t|
      t.integer :noble_metal_id
      t.float :price
      t.date :trade_date
      t.time :trade_time
      t.string :week
      t.float :change_percent

      t.timestamps null: false
    end
  end
end
