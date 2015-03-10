class DailyJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Batter.batter_average
    Batter.qualified_atbats
    Batter.save_snapshot
  end
end
DailyJob.perform_now