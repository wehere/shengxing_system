class Supply::OrderItemsController < BaseController
  before_filter :need_login

  def edit
    @order_item = OrderItem.find(params[:id])
  end

  def update
    puts params
    @order_item = OrderItem.find(params[:id])
    @order_item.update_attribute :plan_weight, params[:order_item_modal_plan_weight]
    @order_item.update_attribute :real_weight, params[:order_item_modal_real_weight]
    @order_item.change_price params[:order_item_modal_price]
    @order_item.update_money
  end
end