require 'rails_helper'

RSpec.describe GameBoard do
  let(:board) { GameBoard.new }

  describe '#current_turn' do
    subject { board.current_turn }
    context 'before a move is made' do
      it { is_expected.to eq "0" }
    end

    context 'after 3 guesses have been made' do
      before do 
        allow(board).to receive(:guesses).and_return(['1', '2', '3'])
      end
      it { is_expected.to eq "3" }
    end
    
    context 'after 10 guesses have been made' do
      before do 
        allow(board).to receive(:guesses).and_return(['1', '2', '3', '4','5','6','7','8','9','10'])
      end
      it { is_expected.to eq "10" }
    end
  end

  describe '#game_over?' do
    subject { board.game_over? }
    context 'turns remaining' do
      before { allow(board).to receive(:guesses).and_return(['1', '2', '3']) }
      
      context 'not a winner...yet' do
        before { allow(board).to receive(:winner?).and_return false }
        it { is_expected.to be false }
      end

      context 'a winner' do
        before { allow(board).to receive(:winner?).and_return true }
        it { is_expected.to be true }
      end
    end

    context 'no turns remaining' do
      before do 
        allow(board).to receive(:guesses).and_return(['1', '2', '3', '4','5','6','7','8','9','10'])
      end
      it { is_expected.to be true }
    end
  end

  describe '#winner?' do
    subject { board.winner? }
    before { allow(board).to receive(:current_turn).and_return("5") }
    
    context 'not a winner' do
      before { allow(board).to receive(:feedback).and_return({"5" => [3,0]}) }
      it { is_expected.to be false }
    end

    context 'a winner' do
      before { allow(board).to receive(:feedback).and_return({"5" => [4,0]}) }
      it { is_expected.to be true }
    end
  end

  describe '#position_check' do
    before { allow(board).to receive(:positions).and_return([:red, :white, :blue, :green]) }
    subject { board.position_check(guess) }
    
    context 'has all right positions' do
      let!(:guess) { [:red, :white, :blue, :green] }

      it { is_expected.to eq 4 }
    end
    
    context 'has only 3 right positions' do
      let!(:guess) { [:red, :blue, :blue, :green] }

      it { is_expected.to eq 3 }
    end
    
    context 'has only 2 right positions' do
      let!(:guess) { [:blue, :blue, :blue, :green] }

      it { is_expected.to eq 2 }
    end
    
    context 'has only 1 right positions' do
      let!(:guess) { [:blue, :blue, :green, :green] }

      it { is_expected.to eq 1 }
    end
    
    context 'has no right positions' do
      let!(:guess) { [:blue, :blue, :green, :white] }

      it { is_expected.to eq 0 }
    end
  end

  describe '#color_check' do
    before { allow(board).to receive(:positions).and_return([:red, :red, :blue, :green]) }
    subject { board.color_check(guess) }
    
    context 'has all right colors' do
      let!(:guess) { [:red, :red, :blue, :green] }

      it { is_expected.to eq 4 }
    end
    
    context 'has only 3 right colors' do
      let!(:guess) { [:white, :blue, :green, :red] }

      it { is_expected.to eq 3 }
    end
    
    context 'has only 2 right colors' do
      let!(:guess) { [:red, :white, :white, :green] }

      it { is_expected.to eq 2 }
    end
    
    context 'has only 1 right positions' do
      let!(:guess) { [:white, :white, :green, :white] }

      it { is_expected.to eq 1 }
    end
    
    context 'has no correct colorss' do
      let!(:guess) { [:white, :white, :white, :white] }

      it { is_expected.to eq 0 }
    end
  end
  
  describe '#check_guess' do
    before { allow(board).to receive(:positions).and_return([:red, :red, :blue, :green]) }

    context 'a winning guess' do
      let!(:guess) { [:red, :red, :blue, :green] }
      it 'saves the response in feedback' do
        board.check_guess(guess)
        expect(board.feedback).to eq({"0" => [4, 0]})
      end
    end
    
    context 'a not winning guess but some right colors' do
      let!(:guess) { [:white, :white, :red, :red] }
      it 'saves the response in feedback' do
        board.check_guess(guess)
        expect(board.feedback).to eq({"0" => [0, 2]})
      end
    end
    
    context 'a not winning guess but some right positions' do
      let!(:guess) { [:white, :white, :blue, :green] }
      it 'saves the response in feedback' do
        board.check_guess(guess)
        expect(board.feedback).to eq({"0" => [2, 0]})
      end
    end

    context 'a not winning guess but mix of right colors and positions' do
      let!(:guess) { [:white, :blue, :white, :green] }
      it 'saves the response in feedback' do
        board.check_guess(guess)
        expect(board.feedback).to eq({"0" => [1, 1]})
      end
    end
  end
end
