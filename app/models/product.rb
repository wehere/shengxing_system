class Product < ActiveRecord::Base
  has_many :prices
  validates_presence_of :simple_abc, :message => '中文缩写不可以为空！'
end
