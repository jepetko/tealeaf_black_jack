#current_dir = File.expand_path('../src', __FILE__)
#Dir["#{current_dir}/**/*.rb"].each { |f| require f }
require_relative '../src/black_jack.rb'

describe 'Black Jack Logic' do

  before(:all) do

    module BlackJack::Interactive

      # log the text said in a buffer
      attr_accessor :text_buff

      def say(text)
        if @text_buff.nil?
          @text_buff = []
        end
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

  end

  describe 'Interactive module' do

    before(:all) do
      @singleton = Object.new
      class << @singleton
        # include the module to be tested
        include BlackJack::Interactive
        # mock methods which normally come from the implementing class
        attr_accessor :players
        attr_accessor :dealer
      end

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

    before(:each) do
      @singleton = Object.new
      class << @singleton
        include BlackJack::BusinessLogic::PlayerIterator
        attr_accessor :players
        attr_accessor :dealer
      end

      @singleton.players = []
      @singleton.dealer = Player.new('<DEALER>')
      5.times { |i| @singleton.players << Player.new("Player #{i}") }
    end

    it 'returns all players' do
      expect(@singleton.all_players.count).to be(6)
    end

    context 'there are active players' do

      before(:each) do
        @accept_player = lambda {|player|
          true
        }
      end

      it 'returns next player' do
        p = @singleton.next_player @accept_player
        expect(p.name).to eq('Player 0')

        p = @singleton.next_player @accept_player
        expect(p.name).to eq('Player 1')

        p = @singleton.next_player @accept_player
        expect(p.name).to eq('Player 2')

        p = @singleton.next_player @accept_player
        expect(p.name).to eq('Player 3')

        p = @singleton.next_player @accept_player
        expect(p.name).to eq('Player 4')

        p = @singleton.next_player @accept_player
        expect(p.name).to eq('<DEALER>')

        p = @singleton.next_player @accept_player
        expect(p.name).to eq('Player 0')
      end
    end

    context 'there are no active players' do

      before(:each) do
        @accept_player = lambda {|player|
          false
        }
      end

      it 'returns nil' do
        p = @singleton.next_player @accept_player
        expect(p).to be_nil
      end
    end

  end

  describe 'Business Logic' do

    before(:all) do
      @logic = BlackJack.new
      @logic.kick_off?
    end

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