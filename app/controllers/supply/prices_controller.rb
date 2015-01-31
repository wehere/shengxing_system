require 'spreadsheet'
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
    begin
      Price.create! price_params
      flash[:success] = '创建成功'
      redirect_to search_supply_prices_path, method: :get
    rescue Exception => e
      flash[:alert] = dispose_exception e
      company = current_user.company
      @product_id = params[:product_id]
      @chinese_name = Product.find(@product_id).chinese_name
      @supplier_id = company.id
      @customers = company.customers
      @year_months = YearMonth.all
      @year_month_id = YearMonth.current_year_month.id
      render :new
    end
  end

  def generate_next_month
    begin
      YearMonth.generate_recent_year_months
      if request.post?
        prices = Price.where(is_used: true, year_month_id: params[:origin_year_month_id], supplier_id: current_user.company.id)
        Price.generate_next_month_batch prices, params[:target_year_month_id]
        flash[:notice] = "成功"
        redirect_to search_supply_prices_path, method: :get
      else
        @year_months = YearMonth.all.order(:id)
        @target_year_month_id = YearMonth.next_year_month.id
        @origin_year_month_id = YearMonth.current_year_month.id
      end
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      redirect_to generate_next_month_supply_prices_path
    end
  end

  def import_prices_from_xls
    @year_months = YearMonth.all
    @year_month_id = YearMonth.current_year_month.id
    company = current_user.company
    @customers = company.customers
    if request.post?
      supplier_id = current_user.company.id
      customer_id = params[:customer_id]
      year_month_id = params[:year_month_id]
      file_io = params[:price_xls]
      flash[:alert] = Price.import_prices_from_xls supplier_id, customer_id, year_month_id, file_io
      redirect_to import_prices_from_xls_supply_prices_path
    end
  end

  def export_xls_of_prices
    @supplier_id = current_user.company.id
    @customers = current_user.company.customers.order(:simple_name)
    @year_months = YearMonth.all.order(:id)
    @current_year_month_id = params[:year_month_id] || YearMonth.current_year_month.id
    if request.post?
      begin
        file_name = Price.export_xls_of_prices @supplier_id, params[:id], params[:year_month_id]
        if File.exists? file_name
          io = File.open(file_name)
          io.binmode
          send_data io.read, filename: file_name, disposition: 'inline'
          io.close
          File.delete file_name
        else
          flash[:alert] = '文件不存在！'
          redirect_to export_xls_of_prices_supply_prices_path
        end
      rescue Exception => e
        flash[:alert] = dispose_exception e
        render :export_xls_of_prices
      end
    end
  end

private
  def price_params
    params.permit([:year_month_id,:customer_id,:product_id,:price,:true_spec,:supplier_id])
  end
end
