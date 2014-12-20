class Order < ActiveRecord::Base
  belongs_to :customer, foreign_key: 'company_id'
  has_many :order_items
  belongs_to :year_month
  belongs_to :store
  belongs_to :order_type
end
