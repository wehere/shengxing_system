class Supply::PricesController < BaseController
  before_filter :need_login
  def index
    @prices = current_user.company.all_prices
  end

  def search
    begin
      company = current_user.company
      @customers = company.customers
      @year_months = YearMonth.all
      if request.post?
        @customer_id = params[:customer_id]
        @year_month_id = params[:year_month_id]
        @search_results = company.supply_prices.where(customer_id: params[:customer_id], year_month_id: params[:year_month_id])
      else
        @customer_id = nil
        @year_month_id = YearMonth.current_year_month.id
        @search_results = nil
      end
    rescue Exception=>e
      flash[:alert] = '查询失败，' + dispose_exception(e)
    end
  end

  def new
    puts params
    company = current_user.company
    @product_id = params[:product_id]
    @chinese_name = Product.find(@product_id).chinese_name
    @supplier_id = company.id
    @customers = company.customers
    @year_months = YearMonth.all
    @year_month_id = YearMonth.current_year_month.id
  end

  def create
    Price.create! price_params
    flash[:success] = '创建成功'
    redirect_to search_supply_prices_path, method: :get
  end

  def generate_next_month

  end
private
  def price_params
    params.permit([:year_month_id,:customer_id,:product_id,:price,:true_spec,:supplier_id])
  end
end
