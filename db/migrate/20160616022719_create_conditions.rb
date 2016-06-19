class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.integer :noble_metal_id
      t.integer :relation
      t.float :value
      t.boolean :is_valid, default: true

      t.timestamps null: false
    end
  end
end
