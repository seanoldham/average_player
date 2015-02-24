class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find params[:id]
    @batters = Batter.find params[:team_id]
  end
end
