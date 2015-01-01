class Purchase::OrdersController < BaseController
  before_filter :need_login
  def index
    @orders = current_user.company.out_orders.where('delete_flag is null or delete_flag = 0')
  end

  def edit
    order = Order.find(params[:id])
    @reach_date = order.reach_order_date
    @order_items = order.order_items
    @sum_money = order.sum_money
  end
end
