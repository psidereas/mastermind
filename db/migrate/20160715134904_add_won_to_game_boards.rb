class AddWonToGameBoards < ActiveRecord::Migration
  def change
    add_column :game_boards, :won, :boolean
  end
end
