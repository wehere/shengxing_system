class GenerateRecentYearMonthsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    YearMonth.generate_recent_year_months
  end
end
