class Purchase::PricesController < BaseController
  before_filter :need_login
  def index
    @prices = current_user.company.all_prices
  end

  def search
    company = current_user.company
    @customers = company.customers
    @year_months = YearMonth.all
    if request.post?
      @customer_id = params[:customer_id]
      @year_month_id = params[:year_month_id]
      @search_results = company.all_prices.where(company_id: params[:customer_id], year_month_id: params[:year_month_id])
      puts @search_results
    else
      @company_id = nil
      @year_month_id = YearMonth.current_year_month.id
      @search_results = nil
    end
  end
end
