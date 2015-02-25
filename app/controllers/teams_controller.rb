class TeamsController < ApplicationController
  def index
    @teams = Team.all
    @avg = Batter.league_average.round(3)
  end

  def show
    @team = Team.find params[:id]
    @batters = @team.batters
  end
end
