module Game
  class GuessChecker
    
    def self.check_guess(guess, positions)
      raise ArgumentError if guess.count != 4
      
      right_positions = position_check(guess, positions)
      right_colors = color_check(guess, positions) - right_positions

      [right_positions, right_colors]
    end

    private 
    
    def self.position_check(guess, positions)
      right_positions, place = 0, 0
      guess.each do |g|
        right_positions += 1 if g == positions[place]
        place += 1
      end
      right_positions
    end

    def self.color_check(guess, positions)
      count = 0
      temp = guess
      positions.each do |pos|
        if temp.include?(pos)
          index = temp.index(pos)
          count += 1
          temp.delete_at(index)
        end
      end
      count
    end
    
  end
end
