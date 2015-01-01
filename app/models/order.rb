class Order < ActiveRecord::Base
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :order_items
  belongs_to :year_month
  belongs_to :store
  belongs_to :order_type

  def sum_money
    self.order_items.sum('money')
  end
end
