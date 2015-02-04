describe 'Black Jack Logic' do

  describe 'Interactive module' do
    it 'asks for the number of players' do
      pending
    end

    it 'asks for the name of the particular player' do
      pending
    end

    it 'prints players score' do
      pending
    end

    it 'prints the winner' do

    end
  end

  describe 'PlayerIterator' do

    context 'there are active players' do

      context 'when the next player is not the dealer' do
        it 'returns next player' do
          pending
        end
      end

      context 'when the next player is the dealer' do
        it 'returns dealer if the sum < 17' do
          pending
        end

        it 'returns player if the sum >= 17' do
          pending
        end
      end
    end

    context 'there are no active players' do
      it 'returns null' do
        pending
      end
    end

  end

  describe 'Business Logic' do

    context 'for dealer' do
      it 'should_draw? returns true if the dealer has less than 17 points' do
        pending
      end

      it 'should_draw? returns false if the dealer has more than 17 points' do
        pending
      end
    end

    context 'for the player' do
      it 'should_draw? returns true if the player says YES' do
        pending
      end

      describe 'SUM computation' do
        it 'computes the sum of all cards' do
          pending
        end

        context 'when there is an ace and the 21 points mark is exceeded' do
          it 'computes an aces as 1' do
            pending
          end
        end

      end

      describe 'busted? method' do
        it 'returns true if the SUM is greater than 21' do
          pending
        end
      end

      describe 'won? method' do
        it 'returns true if the SUM is 21 and there is no further player with 21 points' do
          pending
        end
      end

      describe 'should_stay? method' do
        it 'returns true if the dealer has >= 17 points' do
          pending
        end
      end

      describe 'detect_winner' do
        it 'returns the player with the max. points' do
          pending
        end

        it 'returns null if there are players with the same number of points' do
          pending
        end
      end
    end
  end
end