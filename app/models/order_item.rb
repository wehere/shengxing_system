class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :price
  delegate :chinese_name, to: :product, prefix: true, allow_nil: true
  delegate :real_price, to: :price, prefix: false, allow_nil: false
  def update_money
    self.update_attribute :money, self.real_price*self.real_weight
  end

  def change_price new_price
    self.price.update_attribute :price, new_price
  end

  def self.query_order_items product_name, order_start_date, order_end_date, customer_id, supplier_id
    sql = <<-EOF
      select * from order_items
      left join products on products.id = order_items.product_id
      left join orders on orders.id = order_items.order_id
      where products.`chinese_name` like '%#{product_name}%'
      and orders.`reach_order_date` between '#{order_start_date}' and '#{order_end_date}'
      and orders.`customer_id` = #{customer_id}
      and orders.`supplier_id` = #{supplier_id}
      and (orders.`delete_flag` is null or orders.`delete_flag` = 0 )
    EOF
    OrderItem.find_by_sql(sql)
  end
end
