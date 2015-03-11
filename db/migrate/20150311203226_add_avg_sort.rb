class AddAvgSort < ActiveRecord::Migration
  def change
    remove_column :batter_stats, :batting_average, :float
    add_column :batter_stats, :avg_sort, :decimal
  end
end
