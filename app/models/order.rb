require "spreadsheet"
class Order < ActiveRecord::Base
  belongs_to :supplier, class_name: 'Company', foreign_key: 'supplier_id'
  belongs_to :customer, class_name: 'Company', foreign_key: 'customer_id'
  has_many :order_items
  has_many :comments
  belongs_to :year_month
  belongs_to :store
  belongs_to :order_type
  scope :valid_orders, -> { where("delete_flag is null or delete_flag = 0") }
  def sum_money
    self.order_items.sum('money').round(2)
  end

  def previous previous_type
    if previous_type.blank?
      orders = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id).where("reach_order_date < ?", self.reach_order_date)
      orders = orders.order(:customer_id).order(:store_id).order(order_type_id: :desc)
      orders.where(reach_order_date: orders.maximum('reach_order_date')).first
    else
      previous_order = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id, order_type_id: previous_type.id, reach_order_date: self.reach_order_date).first
      return self.previous( previous_type.previous ) if previous_order.blank?
      previous_order
    end
  end

  def next next_type
    if next_type.blank?
      orders = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id).where("reach_order_date > ?", self.reach_order_date)
      orders = orders.order(:customer_id).order(:store_id).order(order_type_id: :asc)
      orders.where(reach_order_date: orders.minimum('reach_order_date')).first
    else
      next_order = Order.valid_orders.where(customer_id: self.customer_id, store_id: self.store_id, supplier_id: self.supplier_id, order_type_id: next_type.id, reach_order_date: self.reach_order_date).first
      return self.next( next_type.next ) if next_order.blank?
      next_order
    end
  end

  def self.export_order_total_for_specified_days start_date, end_date, customer_id, supplier_id, store_id
    order_type_num = OrderType.where(customer_id: customer_id, supplier_id: supplier_id).count
    customer = Company.find(customer_id)
    # supplier = Company.find(supplier_id)
    store = Store.find(store_id)
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    in_center = Spreadsheet::Format.new horizontal_align: :center, vertical_align: :center, border: :thin
    in_left = Spreadsheet::Format.new horizontal_align: :left, border: :thin
    sheet1 = book.create_worksheet name: '明细'
    sheet1.merge_cells(0,0,0,order_type_num+1)
    sheet1.merge_cells(1,2,1,order_type_num+1)
    sheet1.row(0)[0] = "#{start_date.to_date.to_s(:db)}至#{end_date.to_date.to_s(:db)}#{customer.simple_name}#{store.name}单据明细"
    sheet1.row(0).height = 40
    # big_font = Spreadsheet::Font.new size: 20
    for i in 0..order_type_num+1 do
      sheet1.row(0).set_format(i, in_center)
    end
    sheet1.row(1)[0] = '日期'
    sheet1.row(1).set_format(0, in_center)
    sheet1.row(1)[1] = '每日小计'
    sheet1.row(1).set_format(1, in_center)
    sheet1.row(1)[2] = '详细'
    for j in 2..order_type_num+1 do
      sheet1.row(1).set_format(j, in_center)
    end

    current_row = 2
    all_total_money = 0
    for reach_date in start_date..end_date do
      for x in 0..order_type_num+1
        sheet1.row(current_row)[x] = ''
        sheet1.row(current_row+1)[x] = ''
      end
      sheet1.merge_cells( current_row,0,current_row+1,0)
      sheet1.row(current_row)[0] = reach_date.to_s
      day_total_money = 0
      orders = Order.valid_orders.where(customer_id: customer_id, store_id: store_id, supplier_id: supplier_id, reach_order_date: reach_date).order(:order_type_id)

      orders.each_with_index do |order, index|
        sheet1.row(current_row)[index+2] = order.order_type.name
        sum_money = order.sum_money
        sheet1.row(current_row+1)[index+2] = sum_money
        day_total_money += sum_money
      end
      all_total_money += day_total_money
      sheet1.merge_cells(current_row,1,current_row+1,1)
      sheet1.row(current_row)[1] = day_total_money
      sheet1.row(current_row).set_format(0,in_center)
      sheet1.row(current_row).set_format(1,in_center)
      sheet1.row(current_row+1).set_format(0,in_center)
      sheet1.row(current_row+1).set_format(1,in_center)
      for m in 2..order_type_num+1 do
        sheet1.row(current_row).set_format(m, in_left)
        sheet1.row(current_row+1).set_format(m, in_left)
      end
      current_row += 2
    end
    for n in 0..order_type_num+1
      sheet1.row(3).set_format(n, in_left)
    end
    for y in 0..order_type_num+1
      sheet1.row(current_row)[y] = ''
      sheet1.row(current_row).set_format(y, in_center)
    end
    sheet1.row(current_row)[0] = '总金额'
    sheet1.row(current_row)[1] = all_total_money
    file_path = "#{start_date.to_date.to_s(:db)}至#{end_date.to_date.to_s(:db)}#{customer.simple_name}#{store.name}单据明细.xls"
    book.write file_path
    file_path
  end
end
