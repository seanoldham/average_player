class TeamsController < ApplicationController
  def index
    @teams = Team.all
    @avg = Batter.league_average.round(3).to_s[1..-1]
    @batter_avg = Batter.batter_average
    @average_list = Batter.find_average_batters
    @mr_average = Batter.find_mr_average
  end

  def show
    @team = Team.find params[:id]
    @batters = @team.batters
    @qualified = Batter.qualified_atbats
  end
end
