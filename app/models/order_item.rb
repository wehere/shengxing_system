class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :price
  delegate :chinese_name, to: :product, prefix: true, allow_nil: true
  delegate :real_price, to: :price, prefix: false, allow_nil: false


  validates_presence_of :product, message: '不能没有对应的产品。'
  validates_presence_of :price, message: '不能没有对应的价格。'
  validates_presence_of :order, message: '不能没有对应的单据。'

  def self.create_order_item option
    order_item = self.new option
    order_item.save!
    order_item.reload
    order_item.update_money
    order_item
  end

  def update_money
    self.update_attribute :money, (self.real_price*self.real_weight).round(2)
  end

  def change_price new_price
    self.price.update_attribute :price, new_price
  end

  def self.query_order_items product_name, order_start_date, order_end_date, customer_id, supplier_id
    sql = <<-EOF
      select * from order_items
      left join products on products.id = order_items.product_id
      left join orders on orders.id = order_items.order_id
      where products.`chinese_name` like '%#{product_name}%'
    EOF
    sql += " and orders.`reach_order_date` >= '#{order_start_date}' " unless order_start_date.blank?
    sql += " and orders.`reach_order_date` <= '#{order_end_date}' " unless order_end_date.blank?
    sql += " and orders.`customer_id` = #{customer_id} " unless customer_id.blank?
    sql += " and orders.`supplier_id` = #{supplier_id} " unless supplier_id.blank?
    sql += " and (orders.`delete_flag` is null or orders.`delete_flag` = 0 ) "

    OrderItem.find_by_sql(sql)
  end

  def self.find_null_price supplier_id
    sql = <<-EOF
      select order_items.* from order_items
      left join orders on orders.id = order_items.order_id
      left join prices on prices.id = order_items.price_id
      left join companies on companies.id= orders.customer_id

      where prices.price =0 and prices.is_used=1
      and (orders.delete_flag is null or orders.delete_flag = 0)
      and orders.supplier_id = #{supplier_id}
      and (order_items.delete_flag is null or order_items.delete_flag = 0)
      and orders.reach_order_date > '#{Time.now.to_date.last_month.at_beginning_of_month.to_s}'
    EOF
    OrderItem.find_by_sql(sql)
  end

  def change_delete_status
    self.update_attribute :delete_flag, !self.delete_flag?
  end

  def self.classify supplier_id, specified_date
    sellers = Company.find(supplier_id).sellers
    Spreadsheet.client_encoding = "UTF-8"
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet name: '分菜单'
    format = Spreadsheet::Format.new border: :thin
    merge_format = Spreadsheet::Format.new align: :merge, horizontal_align: :center, border: :thin
    order_items = OrderItem.joins(:order).where("(orders.delete_flag is null or orders.delete_flag = 0) and orders.supplier_id = ? and orders.reach_order_date = ?", supplier_id, specified_date)
    current_row = 0
    sellers.each do |seller|
      sheet1.row(current_row)[0] = seller.name
      current_row += 1
      seller.general_products.each do |general_product|
        some_order_items = order_items.joins(product: :general_product).where("general_products.id = ? ", general_product.id)
        current_col = 0
        sheet1.row(current_row)[current_col] = general_product.name
        sheet1.merge_cells(current_row,current_col,current_row+1,current_col)
        sheet1.row(current_row).set_format(current_col, merge_format)
        sheet1.row(current_row+1).set_format(current_col, merge_format)
        current_col += 1
        some_order_items.each do |s_o_i|
          sheet1.row(current_row)[current_col] = s_o_i.order.customer.simple_name
          sheet1.row(current_row+1)[current_col] = s_o_i.plan_weight
          current_col += 1
        end
        current_row += 2
      end
      current_row += 2
    end
    file_path = specified_date.to_date.to_s(:db) + "_分菜单.xls"
    book.write file_path
    file_path
  end

end
