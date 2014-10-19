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
    def next_player
      all = @players.concat([@dealer])
      idx = @current_player
      loop do
        if idx >= all.length-1
          idx = 0
        else
          idx += 1
        end
        if !busted?(all[idx])
          @current_player = idx
          return all[idx]
        end
      end
      nil
    end

    def should_draw?(player)
      (player.cards.nil? || player.cards.length < 2) ? true : player.draw?
    end

    def sum(player)
      total = player.total
      sum = 0
      player.cards.each do |c|
        if c.ace?
          sum += c.value {total > 21 ? 1 : 11}
        else
          sum += c.value
        end
      end
      sum
    end

    def busted?(player)
      player.total > 21
    end

    def won?(sum)
      sum == 21
    end

    def play
      @dealer = Dealer.new 'Jack'
      @current_player = 0
      @stack = CardStack.new
      loop do
        player = next_player
        if player.nil?
          say 'There are no players.'
        end
        loop do
          if should_draw? player
            card = @dealer.give(@stack)
            say "Your card is: [ #{card.type} ]"
            player.draw(card)
            if busted?(player)
              say 'You are busted!'
            end
          end
        end
      end
    end
  end

  include Interactive
  include BusinessLogic

  def start
    if kick_off?
      play
    end
  end

end

BlackJack.new.start