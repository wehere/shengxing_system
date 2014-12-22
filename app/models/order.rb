class Order < ActiveRecord::Base
  belongs_to :company
  has_many :order_items
  belongs_to :year_month
  belongs_to :store
  belongs_to :order_type
end
