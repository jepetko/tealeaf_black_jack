class BlackJack

  module Interaction
    def say(text)
      print text
    end
    def kick_off
      @players = []
      say 'Welcome to Black Jack. Have fun.'
      say 'Give the number of players at the table:'
      num_of_players = gets.chomp
      if !num_of_players.chomp.match(/^[0-9]+$/).nil?
        num_of_players.to_i.times do |i|
          say "Player ##{i}"
          @players << Player.new(gets.chomp)
        end
      else
        say 'game terminated. The number of players not valid.'
      end
    end
  end

  module BusinessLogic

  end
  include Interaction
end