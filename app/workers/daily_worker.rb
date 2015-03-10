class DailyWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  def perform(*args)
    # Scrapable rake task goes here. How?
    Batter.batter_average
    Batter.qualified_atbats
    Batter.save_snapshot
  end
end

