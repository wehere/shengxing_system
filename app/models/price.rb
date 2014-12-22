class Price < ActiveRecord::Base
  belongs_to :year_month
  belongs_to :product
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :price_change_historieses
  scope :prices_in, ->(year_month_id) { where(year_month_id: year_month_id)}

end
