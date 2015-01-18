class Product < ActiveRecord::Base
  has_many :prices
  belongs_to :supplier, foreign_key: :supplier_id, class_name: :Company
  validates_presence_of :simple_abc, :message => '中文缩写不可以为空！'
end
