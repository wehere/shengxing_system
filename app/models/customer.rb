class Customer < ActiveRecord::Base
  # self.table_name = 'companies'
  # has_many :orders,-> { where("delete_flag is null or delete_flag = 0") }, foreign_key: 'company_id'
  # belongs_to :company, foreign_key: 'parent_id'
  # has_many :prices, foreign_key: 'company_id'
  # has_many :order_types, foreign_key: 'company_id'
  # has_many :order_items, through: :orders
  # has_many :stores, foreign_key: 'company_id'
  #
  # # scope :prices_in, ->(year_month_id) { Price.prices_in( year_month_id).where(company_id: self.id)}
  #
  # def prices_by_year_month year_month_id
  #   self.prices.where(year_month_id: year_month_id)
  # end
end
