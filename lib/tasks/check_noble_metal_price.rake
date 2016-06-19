namespace :noble_metal_price do
  desc "提交代码"
  task :check do
    Trade.check
  end
end
