namespace :price do
  desc "提交代码"
  task :generate_next_month_price => :environment do
    if Time.now.to_date == Time.now.end_of_month.to_date
      GenerateRecentYearMonthsJob.perform_later()
      Company.all_suppliers.each do |supplier|
        GNextMonthPriceJob.perform_later(supplier.id)
      end
    end
  end
end
