class Company < ActiveRecord::Base
  has_many :users
  has_many :prices, through: :customers
  has_many :orders, through: :customers
  has_many :customers, foreign_key: 'parent_id'


  def all_prices
    Price.where("company_id in ( ? )", self.customers.ids)
  end

  def all_orders
    self.customers.collect { |cus| cus.orders }.flatten!
  end

end
