class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  delegate :chinese_name, to: :product, prefix: true, allow_nil: true
end
