class OrderType < ActiveRecord::Base
  belongs_to :customer, foreign_key: 'company_id'
  has_many :orders
end
