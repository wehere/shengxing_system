class OrderType < ActiveRecord::Base
  has_many :orders
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  validates_presence_of :name
end
