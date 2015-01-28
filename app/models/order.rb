class Order < ActiveRecord::Base
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :order_items
  has_many :comments
  belongs_to :year_month
  belongs_to :store
  belongs_to :order_type
  scope :valid_orders, -> { where("delete_flag is null or delete_flag = 0") }
  def sum_money
    self.order_items.sum('money').round(2)
  end

  def previous previous_type
    if previous_type.blank?
      orders = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id).where("reach_order_date < ?", self.reach_order_date)
      orders = orders.order(:customer_id).order(:store_id).order(order_type_id: :desc)
      orders.where(reach_order_date: orders.maximum('reach_order_date')).first
    else
      previous_order = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id, order_type_id: previous_type.id, reach_order_date: self.reach_order_date).first
      return self.previous( previous_type.previous ) if previous_order.blank?
      previous_order
    end
  end

  def next next_type
    if next_type.blank?
      orders = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id).where("reach_order_date > ?", self.reach_order_date)
      orders = orders.order(:customer_id).order(:store_id).order(order_type_id: :asc)
      orders.where(reach_order_date: orders.minimum('reach_order_date')).first
    else
      next_order = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id, order_type_id: next_type.id, reach_order_date: self.reach_order_date).first
      return self.next( next_type.next ) if next_order.blank?
      next_order
    end
  end

end
