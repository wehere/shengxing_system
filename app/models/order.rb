class Order < ActiveRecord::Base
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :order_items
  belongs_to :year_month
  belongs_to :store
  belongs_to :order_type
  scope :valid_orders, -> { where("delete_flag is null or delete_flag = 0") }
  def sum_money
    self.order_items.sum('money').round(2)
  end

  def previous
    orders = Order.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id).where("reach_order_date < ?", self.reach_order_date)
    puts orders.maximum('reach_order_date')
    orders.where(reach_order_date: orders.maximum('reach_order_date')).first
  end

  def next
    orders = Order.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id).where("reach_order_date > ?", self.reach_order_date)
    puts orders.minimum('reach_order_date')
    orders.where(reach_order_date: orders.minimum('reach_order_date')).first
  end

end
