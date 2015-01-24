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

end
