class CreateGameBoards < ActiveRecord::Migration
  def change
    create_table :game_boards do |t|
      t.text :positions, array: true, default: []
      t.integer :turns
      t.text :guesses, array: true, default: []
      t.column :feedback, :json

      t.timestamps null: false
    end
  end
end
