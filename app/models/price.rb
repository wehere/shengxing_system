class Price < ActiveRecord::Base
  has_one :year_month
  has_one :product
  has_one :company
end
