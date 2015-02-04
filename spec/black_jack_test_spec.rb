#current_dir = File.expand_path('../src', __FILE__)
#Dir["#{current_dir}/**/*.rb"].each { |f| require f }
require_relative '../src/black_jack.rb'

describe 'Black Jack Logic' do

  describe 'Interactive module' do
    before(:all) do

      module BlackJack::Interactive
        attr_accessor :text_buff
        def say(text)
          @text_buff << text
        end

        def ask_for_number_of_players
          '3'
        end

        def ask_for_the_player_name
          @counter ||= 0
          name = ''
          case @counter
            when 0
              name = 'Ramin'
            when 1
              name = 'Kati'
            when 2
              name = 'Juje'
          end
          @counter = @counter + 1
          name
        end
      end

      @singleton = Object.new
      class << @singleton
        include BlackJack::Interactive

        # Note: for some reason attr_accessors don't work here
        def players=(p)
          @players = p
        end
        def players
          @players
        end
        def dealer=(d)
          @dealer = d
        end
        def dealer
          @dealer
        end
      end

      @singleton.text_buff = []
      @singleton.players = []
      @singleton.dealer = Player.new('<DEALER>')
    end

    before(:each) do
      @singleton.text_buff.clear
      @singleton.kick_off?
    end

    it 'asks for the number of players and the names of the players' do
      expect(@singleton.players.count).to be(3)
      puts @singleton.players.inspect
      expect(@singleton.players.first.name).to eq('Ramin')
      expect(@singleton.players.last.name). to eq('Juje')
    end

    it 'prints players score' do
      @singleton.print_results do |player|
        10
      end

      buff = @singleton.text_buff.join(';')
      expect(buff).to match(/#1 Ramin: 10/)
      expect(buff).to match(/#2 Kati: 10/)
      expect(buff).to match(/#3 Juje: 10/)
    end

    it 'prints the winner' do

      winner = @singleton.players.first
      @singleton.print_winner winner

      expect(winner.name).to eq('Ramin')
      expect(@singleton.text_buff.last).to eq('-+-+-+-+-+-+ Winner is Ramin. -+-+-+-+-+-+')
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