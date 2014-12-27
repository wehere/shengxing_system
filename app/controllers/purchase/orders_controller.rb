class Purchase::OrdersController < BaseController
  def index
    @orders = current_user.company.out_orders
  end

  def edit
    order = Order.find(params[:id])
    @reach_date = order.reach_order_date
    @order_items = order.order_items
  end
end
