require 'game/guess_checker'

class GameBoard < ActiveRecord::Base

  serialize :positions, Array
  serialize :guesses, Array
  serialize :feedback, Hash

  COLORS = {
    red:    "Red",
    blue:   "Blue",
    green:  "Green",
    yellow: "Yellow",
  }

  # Add stats here to display in view... ex.) avg guesses per win, most common starter
  def self.winner_stats
    winners = where(won: true)
    avg_guesses = winners.map { |winner| winner.guesses.count }.sum / winners.count.to_f
    {
      count:  winners.count,
      avg_guesses: avg_guesses
    }
  end

  def initialize(turns: 10)
    super
    @turns = turns
    initiate_starting_positions
  end

  def current_turn
    guesses.count.to_s
  end

  def game_over?
    turns == guesses.count || winner?
  end

  def last_guess
    guesses.last.map(&:to_s)
  end

  def winner?
    if feedback[current_turn].try(:first) == 4
      self.update_attributes(won: true)
    end
    self.won?
  end
  
  def board_layout
    layout = []
    count = 1
    guesses.each do |g|
      layout << g + feedback[count.to_s]
      count += 1
    end
    blank_rows.times do
      layout << [:blank, :blank, :blank, :blank, "0", "0"]
    end
    layout
  end

  def blank_rows
    turns - guesses.count
  end

  private

  # Keep starting positions of 4 hardcoded for now to mimic real game
  # Can customize in the future to make it harder
  def initiate_starting_positions(starter = 4)
    starter.times do
      self.positions << COLORS.keys.sample(1)
    end
    self.positions.flatten!
    save!
  end
end
