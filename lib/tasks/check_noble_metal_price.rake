namespace :noble_metal_price do
  desc "提交代码"
  task :check => :environment do
    Trade.check
  end
end
