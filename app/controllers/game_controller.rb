require 'game/play'

class GameController < ApplicationController

  def index
    @winner_stats = GameBoard.winner_stats
    @board = GameBoard.new
  end

  def show
    @colors = GameBoard::COLORS.invert.to_a
    @board = GameBoard.find(params[:id])
  end
  
  def guess
    @board = GameBoard.find(params[:id])
    colors = params[:game]
    Game::Play.new(game_board: @board).play_turn(colors.values.to_a.map { |x| x.to_sym })
    render action: 'show'
  end
end
