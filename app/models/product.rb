class Product < ActiveRecord::Base
  has_many :prices
  belongs_to :supplier, foreign_key: :supplier_id, class_name: :Company
  validates_presence_of :simple_abc, :message => '中文缩写不可以为空！'
  validate :validate

  def validate
    errors.add(:product_id, "产品名称已经存在，请选用其他产品名称！") if Product.where(supplier_id: supplier_id, chinese_name: chinese_name).count >= 1
  end
end
