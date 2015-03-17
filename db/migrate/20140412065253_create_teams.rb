class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams, id: false do |t|
      t.integer :id, null: false
      t.integer :league_id, null: false
      t.string :name, null: false
      t.string :abbrev, null: false
      t.timestamps
    end

    add_index :teams, :id, unique: true
  end
end
