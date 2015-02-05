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

      @singleton.text_buff = []
      @singleton.players = []
      @singleton.dealer = Dealer.new('<DEALER>')
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
      @singleton.dealer = Dealer.new('<DEALER>')
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

    before(:each) do
      module Player::Interactive
        def draw?
          true
        end
      end
    end

    before(:each) do
      @logic = BlackJack.new
      @logic.kick_off?
      @logic.dealer = Dealer.new('<DEALER>')
    end

    context 'for dealer' do
      it 'should_draw? returns true if the dealer has less than 17 points' do
        @logic.dealer.draw Card.new(10)
        @logic.dealer.draw Card.new(6)
        expect(@logic.should_draw?(@logic.dealer)).to be(true)
      end

      it 'should_draw? returns false if the dealer has more than 17 points' do
        @logic.dealer.draw Card.new(10)
        @logic.dealer.draw Card.new(6)
        @logic.dealer.draw Card.new(2)
        expect(@logic.should_draw?(@logic.dealer)).to be(false)
      end
    end

    context 'for the player' do

      it 'should_draw? returns true if the player says YES' do
        expect(@logic.should_draw?(@logic.players.first)).to be(true)
      end

      describe 'SUM computation' do

        before(:each) do
          @p = @logic.players.first
          @p.draw Card.new(4)
          @p.draw Card.new(10)
        end

        it 'computes the sum of all cards' do
          expect(@logic.sum(@p)).to be(14)
        end

        context 'when there is an ace and the 21 points mark is exceeded' do
          it 'computes an aces as 1' do
            @p.draw Card.new('Ace', 1)
            expect(@logic.sum(@p)).to be(15)
          end
        end

      end

      describe 'busted? method' do

        before(:each) do
          @p = @logic.players.first
        end

        it 'returns true if the SUM is greater than 21' do
          @p.draw Card.new(2)
          @p.draw Card.new(10)
          @p.draw Card.new('King',10)

          expect(@logic.busted?(@p)).to be(true)
        end
      end

      describe 'won? method' do

        context 'returns false if the player has less than 21 points' do
          it 'returns false' do
            @logic.players.first.draw Card.new(10)
            expect(@logic.won?(@logic.players.first)).to be(false)
          end
        end

        context 'there are no further players with 21 points' do
          it 'returns true' do
            @logic.players.first.draw Card.new(2)
            @logic.players.last.draw Card.new(10)
            @logic.players.last.draw Card.new('Ace', 11)

            expect(@logic.won?(@logic.players.last)).to be(true)
          end
        end

        context 'there is another player with 21 points' do
          it 'returns false' do
            @logic.players.first.draw Card.new(10)
            @logic.players.first.draw Card.new(9)
            @logic.players.first.draw Card.new(2)

            @logic.players.last.draw Card.new(10)
            @logic.players.last.draw Card.new('Ace', 11)

            expect(@logic.won?(@logic.players.first)).to be(false)
            expect(@logic.won?(@logic.players.last)).to be(false)
          end
        end
      end

      describe 'detect_winner' do
        it 'returns the player with the max. points' do
          @logic.players.each { |p| p.draw Card.new(10) }
          @logic.players[1].draw Card.new(5)

          expect(@logic.detect_winner).to be(@logic.players[1])
        end

        it 'returns null if there are players with the same number of points' do
          @logic.players.each { |p| p.draw Card.new(10) }

          expect(@logic.detect_winner).to be_nil
        end
      end
    end
  end
end