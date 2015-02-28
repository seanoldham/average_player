class AddQualifiedToBatterStats < ActiveRecord::Migration
  def change
    add_column :batter_stats, :qualified, :boolean, default: true
  end
end
