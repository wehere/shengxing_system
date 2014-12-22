class Company < ActiveRecord::Base
  has_many :users
  has_many :prices, through: :customers
  has_many :orders, through: :customers
  has_many :relations, foreign_key: 'company_id', class_name: 'CustomersCompanies'
  has_many :customers, through: :relations, source: :purchaser
  has_many :reverse_relations, foreign_key: 'customer_id', class_name: 'CustomersCompanies'
  has_many :supplies, through: :reverse_relations, source: :supplier
  has_many :orders
  has_many :order_items, through: :orders
  has_many :stores
  has_many :order_types
  has_many :in_orders, through: :customers, class_name: 'Company'
  def all_prices
    Price.where("company_id in ( ? )", self.customers.ids)
  end

  def all_orders
    self.customers.collect { |cus| cus.orders }.flatten!
  end

end
