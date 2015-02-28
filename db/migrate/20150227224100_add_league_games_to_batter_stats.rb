class AddLeagueGamesToBatterStats < ActiveRecord::Migration
  def change
    add_column :batter_stats, :league_games, :integer
  end
end
