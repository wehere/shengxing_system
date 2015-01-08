class OrderMessageMailer < ApplicationMailer
  default from: "864454373@qq.com"

  def order_message_email customer_id, supplier_id, content, need_reach_date
    @content = content
    @customer = Company.find(customer_id)
    @need_reach_date = need_reach_date
    address = Company.find(supplier_id).users.collect {|u| u.email}
    mail(to: address.shift, recient: address, subject: "#{@customer.simple_name}的订单")
  end
end
