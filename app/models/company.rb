class Company < ActiveRecord::Base
  has_many :users
  has_many :get_prices, foreign_key: 'customer_id', class_name: 'Price' #得到的价格
  has_many :supply_prices, foreign_key: 'supplier_id', class_name: 'Price' #由自己提供的价格
  has_many :relations, foreign_key: 'company_id', class_name: 'CustomersCompanies'
  has_many :customers, through: :relations, source: :purchaser #下家，即我的客户
  has_many :reverse_relations, foreign_key: 'customer_id', class_name: 'CustomersCompanies'
  has_many :supplies, through: :reverse_relations, source: :supplier #上家，即我的供应商
  has_many :stores
  has_many :get_order_types, foreign_key: 'customer_id', class_name: 'OrderType' #对于该公司我提供的单据类型
  has_many :supply_order_types, foreign_key: 'supplier_id', class_name: 'OrderType' #给我提供的单据类型
  has_many :out_orders, foreign_key: 'customer_id', class_name: 'Order'#向供应商发的订单
  has_many :out_order_items, through: :out_orders, class_name: 'OrderItem'
  has_many :in_orders, foreign_key: 'supplier_id', class_name: 'Order' #自己收到的所有订单
  has_many :in_order_items, through: :in_orders, class_name: 'OrderItem'
  def all_prices
    Price.where("customer_id in ( ? )", self.customers.ids)
  end

  def all_orders
    self.customers.collect { |cus| cus.orders }.flatten!
  end

end
