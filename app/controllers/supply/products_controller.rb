class Supply::ProductsController < BaseController
  before_filter :need_login
  def index
    begin
      @key_value = params[:key]
      unless params[:key].blank?
        @products = Product.where("id = ? or chinese_name like ? or simple_abc like ? ", params[:key],"%#{params[:key]}%","%#{params[:key]}%")
      else
        @products = Product.all
      end
    rescue Exception=>e
      flash[:alert] = '查询失败，' + dispose_exception(e)
    end
  end

  def create
    begin
      product = Product.new product_params
      product.save!
      flash[:notice] = "创建成功"
      redirect_to new_supply_product_path
    rescue Exception => e
      flash[:alert] = dispose_exception e
      @product = product
      render new_supply_product_path
    end
  end

  def new
    @product = Product.new
  end

  private
    def product_params
      params.require(:product).permit([:english_name,:chinese_name,:spec,:simple_abc])
    end
end