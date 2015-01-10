require "spreadsheet"
class Price < ActiveRecord::Base
  belongs_to :year_month
  belongs_to :product
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :price_change_historieses
  has_many :order_items
  scope :prices_in, ->(year_month_id) { where(year_month_id: year_month_id)}

  def real_price
    self.price
  end

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

  def self.import_prices_from_xls  supplier_id, customer_id, year_month_id, file_io
    message = '导入开始于' + Time.now.to_s + '\r'
    name = file_io.original_filename
    origin_name_with_path = Rails.root.join('public', name)
    File.open(origin_name_with_path, 'wb') do |file|
      file.write(file_io.read)
    end
    book = Spreadsheet.open origin_name_with_path
    sheet = book.worksheet 0
    self.transaction do
      sheet.each_with_index do |row, index|
        next if index==0
        product_name = row[1]
        product = Product.find_by_chinese_name(product_name)
        if product.blank?
          message += product_name + '不在产品列表中'
          next
        end

        found_prices = Price.where(supplier_id: supplier_id, customer_id: customer_id, year_month_id: year_month_id, product_id: product.id)
        unless found_prices.blank?
          message += product_name + '已经存在于价格表中'
          next
        end
        price = row[2]
        true_spec = row[3]
        Price.create!(price: price, true_spec: true_spec, is_used: true,
                              customer_id: customer_id, supplier_id: supplier_id,
                              year_month_id: year_month_id, product_id: product.id )
      end
    end
    File.delete origin_name_with_path
    message
  end
end
