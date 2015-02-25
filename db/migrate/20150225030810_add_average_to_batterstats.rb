class AddAverageToBatterstats < ActiveRecord::Migration
  def change
    add_column :batter_stats, :batting_average, :float
  end
end
