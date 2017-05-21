require 'game/guess_checker'

module Game
  class Play

    attr_reader :board
    
    delegate :current_turn, :positions, :turns, :winner?, :game_over?, :to => :board
    
    WINNING_MSG = "HEY, HEY! YOU WON!"
    LOSING_MSG  = "sorry...you lost... :("

    def initialize(game_board: nil)
      @board = game_board || GameBoard.new
    end

    def play_turn(guess)
      return "Game is over, no more guesses allowed" if game_over?
      board.guesses = board.guesses << guess
      results = Game::GuessChecker.check_guess(guess, positions)
      board.feedback = board.feedback.merge({current_turn => results})
      board.save
    
      turn_response
    end

    private
    
    #This method will check if the game is over and return the appropriate
    #response. If game is not over it will update the guess feedback
    def turn_response
      if game_over?
        winner? ? WINNING_MSG : LOSING_MSG
      else
        board.feedback[current_turn]
      end
    end
  end
end
