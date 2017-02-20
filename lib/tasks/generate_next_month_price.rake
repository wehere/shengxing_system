namespace :price do
  desc "提交代码"
  task :generate_next_month_price => :environment do
    if Time.now.to_date == Time.now.end_of_month.to_date
      YearMonth.delay.generate_recent_year_months
      Company.all_suppliers.each do |supplier|
        Price.delay.g_next_month_price YearMonth.current_year_month.id, YearMonth.next_year_month.id, supplier.id
      end
    end
  end
end