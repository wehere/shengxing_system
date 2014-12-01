class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :price_id
      t.integer :year_month_id
      t.integer :company_id
      t.integer :product_id
      t.string :plan_weight
      t.float :real_weight
      t.float :money

      t.timestamps
    end
  end
end
