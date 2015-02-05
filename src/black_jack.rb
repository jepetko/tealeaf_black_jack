require_relative './player'
require_relative './dealer'
require_relative './card_stack'

class BlackJack

  module Interactive
    def say(text)
      puts text
    end
    def ask_for_number_of_players
      gets.chomp
    end
    def ask_for_the_player_name
      gets.chomp
    end
    def kick_off?
      say 'Welcome to Black Jack. Have fun.'
      say 'Give the number of players at the table:'
      num_of_players = ask_for_number_of_players
      if !num_of_players.match(/^[0-9]+$/).nil?
        num_of_players.to_i.times do |i|
          say "Player ##{i+1}:"
          players << Player.new(ask_for_the_player_name)
        end
      else
        say 'The number of players is not valid.'
      end
      !players.empty?
    end
    def print_results(&players_score)
      (players + [dealer]).each_with_index do |player,idx|
        say "##{idx+1} #{player.name}: #{players_score.call(player)}"
      end
    end
    def print_winner(winner)
      if winner.nil?
        say '-+-+-+-+-+-+ Winner is no one. -+-+-+-+-+-+'
      else
        say "-+-+-+-+-+-+ Winner is #{winner.name}. -+-+-+-+-+-+"
      end
    end
  end

  module BusinessLogic
    module PlayerIterator
      def all_players
        players + [dealer]
      end
      def next_player(accept_player_block)

        all = all_players
        @current_player_idx ||= -1

        idx = @current_player_idx
        loop do
          if idx >= all.length-1
            # fix endless loop
            return nil if @current_player_idx == -1
            idx = 0
          else
            idx += 1
          end
          #there is no available player anymore..everyone busted?
          if idx == @current_player_idx
            return nil
          end
          if accept_player_block.call(all[idx])
            @current_player_idx = idx
            return all[idx]
          end
        end
        nil
      end
    end
    include PlayerIterator

    def should_draw?(player)
      if player.is_a?(Dealer)
        !should_stay?(player)
      else
        player.draw?
      end
    end

    def sum(player)
      total = player.total
      if total > 21
        total = 0
        player.cards.each do |c|
          if c.ace?
            total += c.value {1}
          else
            total += c.value
          end
        end
      end
      total
    end

    def busted?(player, &when_busted)
      sum = sum(player)
      busted = sum > 21
      if busted && !when_busted.nil?
        when_busted.call sum
      end
      busted
    end

    def won?(player)
      sum(player) == 21 && !detect_winner.nil?
    end

    def should_stay?(dealer)
      sum(dealer) >= 17
    end

    def handle_player(player)
      loop do
        say player.drawn_cards_as_str
        break if !should_draw?(player)
        card = dealer.give(stack)
        say "Your card is: [ #{card.type} ]"
        player.draw(card)
        break if busted?(player) {|sum| say ".. #{player.name}, you are busted! Your sum: #{sum}."}
      end
    end

    def detect_winner
      eligible_players = all_players.select { |p| !busted?(p)}
      sorted = eligible_players.sort do |p1,p2|
        sum(p1) - sum(p2)
      end
      len = sorted.length
      # tie
      if len > 1
        return nil if sum(sorted.last) == sum(sorted[sorted.length-2])
      end
      sorted.last
    end

    def play
      # give everyone two cards
      say '*********************************'
      say 'Giving cards:'
      2.times do
        all_players.each do |player|
          card = dealer.give stack
          player.draw card
        end
        print_results {|player| sum(player)}
      end
      say '*********************************'

      loop do
        if busted?(dealer)
          say "Dealer lost! Dealer's score: #{sum(dealer)}"
          say 'Here are the final results:'
          print_results {|player| sum(player)}
          break
        elsif won?(dealer)
          say "Dealer won! Dealer's score: #{sum(dealer)}"
          break
        elsif should_stay?(dealer)
          say "Dealer's limit reached: #{sum(dealer)}"
          say 'Here are the final results:'
          print_results {|player| sum(player)}
          break
        else
          # detect the next player. Player can be asked:
          # a) if he is not busted
          # b) if he is not the *dealer* whose score >= 17 (then he must stay)
          accept_player = lambda {|player|
            if busted?(player)
              return false
            else
              if player.is_a?(Dealer)
                return !should_stay?(player)
              end
            end
            true
          }
          player = next_player accept_player
          say '*********************************'
          say "Dear #{player.name}, you are the next player."
          handle_player player
        end
      end
      print_winner detect_winner
    end
  end

  include Interactive
  include BusinessLogic

  attr_accessor :dealer
  attr_accessor :players
  attr_accessor :stack

  def initialize
    @dealer = Dealer.new '<DEALER>'
    @players = []
    @stack = CardStack.new
  end

  def start
    if kick_off?
      play
    end
  end

end

BlackJack.new.start