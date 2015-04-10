# pull all data
class TeamsController < ApplicationController
  def index
    @find_mr_average = Batter.find_by_id(Snapshot.last.mr_average_id)
  end

  def show
    @team = Team.find params[:id]
    @batters = @team.batters
  end

  def yesterday
    yesterday_snapshot = Snapshot.find_by "DATE(created_at) = ?", 1.day.ago
    @find_yesterday_mr_average = Batter.find_by_id(yesterday_snapshot.mr_average_id)
  end

  def snapshot
    %x[rake scrape:all]
    @avg = Batter.league_average.round(3).to_s[1..-1]
    @qualified = Batter.qualified_atbats
    @average_list = Batter.find_average_batters
    @snapshot = Batter.save_snapshot
    redirect_to root_url
  end
end
