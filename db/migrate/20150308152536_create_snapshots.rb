class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.decimal :league_average
      t.integer :mr_average_id
      t.timestamps null: false
    end
  end
end
