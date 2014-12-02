class Sp::ProductsController < ApplicationController
  def index

  end

  def create
    Product.create! product_params
    flash[:notice] = "创建成功"
    redirect_to new_sp_product_path
  end

  def new
    @product = Product.new
  end

  private
    def product_params
      params.require(:product).permit([:english_name,:chinese_name,:spec,:simple_abc])
    end
end