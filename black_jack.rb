require './player'
require './dealer'
require './card_stack'

class BlackJack

  module Interactive
    def say(text)
      puts text
    end
    def kick_off?
      @players = []
      say 'Welcome to Black Jack. Have fun.'
      say 'Give the number of players at the table:'
      num_of_players = gets.chomp
      if !num_of_players.chomp.match(/^[0-9]+$/).nil?
        num_of_players.to_i.times do |i|
          say "Player ##{i}:"
          @players << Player.new(gets.chomp)
        end
      else
        say 'The number of players is not valid.'
      end
      !@players.empty?
    end
  end

  module BusinessLogic

    def all_players
      @players.concat([@dealer])
    end

    def next_player
      all = all_players
      idx = @current_player
      loop do
        if idx >= all.length-1
          idx = 0
        else
          idx += 1
        end
        #there is no available player anymore..everyone busted?
        if idx == @current_player
          return nil
        end
        if !busted?(all[idx])
          @current_player = idx
          return all[idx]
        end
      end
      nil
    end

    def should_draw?(player)
      player.draw?
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
      sum(player) == 21
    end

    def handle_player(player)
      loop do
        say player.current_cards_as_str
        break if !should_draw?(player)
        card = @dealer.give(@stack)
        say "Your card is: [ #{card.type} ]"
        player.draw(card)
        break if busted?(player) {|sum| say "You are busted! Total sum: #{sum}."}
      end
    end

    def play
      # give everyone two cards
      2.times do
        all_players.each do |player|
          card = @dealer.give @stack
          player.draw card
        end
      end
      # ... then start to ask ... draw OR stay
      loop do
        player = next_player
        if player.nil?
          say 'There are no players. Everyone is busted.'
          break
        else
          say '*********************************************'
          say "Dear #{player.name}, you are the next player."
          handle_player player
        end
      end
    end
  end

  include Interactive
  include BusinessLogic

  def initialize
    @dealer = Dealer.new 'Jack'
    @current_player = -1
    @stack = CardStack.new
  end

  def start
    if kick_off?
      play
    end
  end

end

BlackJack.new.start