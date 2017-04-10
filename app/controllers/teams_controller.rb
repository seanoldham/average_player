# pull all data
class TeamsController < ApplicationController
  def index
    @find_mr_average = Batter.find_by_id(Snapshot.last.mr_average_id)
  end
end
