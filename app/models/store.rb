class Store < ActiveRecord::Base
  has_many :orders
  belongs_to :customer, foreign_key: 'company_id'
end
