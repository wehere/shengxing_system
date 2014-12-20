class YearMonth < ActiveRecord::Base
  has_many :orders
  has_many :order_items, through: :orders
  scope :current_year_month, -> { where(val: Time.now.to_date.to_s(:db)[0..-4].gsub('-','年')+'月').first }
end
