class CreateBatters < ActiveRecord::Migration
  def change
    create_table :batters, id: false do |t|
      t.integer :id, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :bats, limit: 1, null: false
      t.integer :pos, limit: 1, null: false
      t.integer :jersey_number, null: false
      t.belongs_to :team, null: false
      t.timestamps
    end

    add_index :batters, :team_id
    add_index :batters, :id, unique: true
  end
end
