class CreateBatterStats < ActiveRecord::Migration
  def change
    create_table :batter_stats do |t|
      t.belongs_to :batter, null: false
      t.integer :h, null: false
      t.integer :ab, null: false
      t.integer :tb, null: false
      t.integer :r, null: false
      t.integer :b2, null: false
      t.integer :b3, null: false
      t.integer :hr, null: false
      t.integer :rbi, null: false
      t.integer :sac, null: false
      t.integer :sf, null: false
      t.integer :hbp, null: false
      t.integer :bb, null: false
      t.integer :ibb, null: false
      t.integer :so, null: false
      t.integer :sb, null: false
      t.integer :cs, null: false
      t.integer :gidp, null: false
      t.integer :np, null: false
      t.integer :go, null: false
      t.integer :ao, null: false
      t.integer :tpa, null: false
      t.integer :league_games
      t.boolean :qualified
      t.decimal :avg_sort
      t.timestamps
    end
    add_index :batter_stats, :batter_id, unique: true
  end
end
