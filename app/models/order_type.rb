class OrderType < ActiveRecord::Base
  has_many :orders
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  validates_presence_of :name

  def previous
    all_order_types = self.customer.get_order_types.order(:id)
    count = all_order_types.count
    return nil if count == 1 or count == 0
    pos = -1
    0.upto count-1 do |i|
      if all_order_types[i].name == self.name
        pos = i
        break
      end
    end
    return nil if pos == -1
    return nil if pos == 0
    return all_order_types[pos - 1]
  end

  def next
    all_order_types = self.customer.get_order_types.order(:id)
    count = all_order_types.count
    return nil if count == 1 or count == 0
    pos = -1
    0.upto count-1 do |i|
      if all_order_types[i].name == self.name
        pos = i
        break
      end
    end
    return nil if pos == -1
    return nil if pos == count - 1
    return all_order_types[pos + 1]
  end
end
