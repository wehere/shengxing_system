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

  def new
    @supplies = current_user.company.supplies
    @customer_id = current_user.company.id
  end

  def send_message
    OrderMessageMailer.order_message_email(params[:customer_id],params[:supplier_id],params[:content],params[:need_reach_date]).deliver
    flash[:notice] = '发信成功'
    redirect_to welcome_vis_static_pages_path
  end
end
