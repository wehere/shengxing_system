class Supply::OrdersController < BaseController
  before_filter :need_login
  def index
    @key = params[:key]
    @date_start = params[:date_start].blank? ? Time.now.to_date : params[:date_start]
    @date_end = params[:date_end].blank? ? Time.now.to_date : params[:date_end]
    @orders = current_user.company.in_orders.where("delete_flag is null or delete_flag = 0")
    if !params[:date_start].blank? && !params[:date_end].blank?
      @orders = @orders.where(reach_order_date: params[:date_start]..params[:date_end])
    end
    unless params[:key].blank?
      @orders = @orders.where("id = ? or customer_id = ?", params[:key], params[:key])
    end
  end
end
