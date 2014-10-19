require './player'
require './dealer'

class BlackJack

  module Interaction
    def say(text)
      puts text
    end
    def kick_off
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
        say 'Game terminated. The number of players is not valid.'
      end
    end
  end

  module BusinessLogic
    def next_player
      @players.concat([@dealer])[@current_player+=1]
    end

    def play
      @dealer = Dealer.new 'Jack'
      @current_player = 0
      @stack = CardStack.new
      loop do
        player = next_player
        loop do
          card = @dealer.give(@stack)
        end
      end
    end
  end

  include Interaction


end

BlackJack.new.kick_off