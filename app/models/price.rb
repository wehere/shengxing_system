class Price < ActiveRecord::Base
  belongs_to :year_month
  belongs_to :product
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :price_change_historieses
  scope :prices_in, ->(year_month_id) { where(year_month_id: year_month_id)}

  def generate_next_month next_month_id
    return nil if Price.exists? year_month_id: next_month_id, customer_id: self.customer_id, product_id: self.product_id, supplier_id: self.supplier_id
    new_price = self.dup
    new_price.update_attributes year_month_id: next_month_id
    new_price.save!
  end

  def self.generate_next_month_batch prices, next_month_id
    self.transaction do
      prices.each do |price|
        price.generate_next_month next_month_id
      end
    end
  end
end
