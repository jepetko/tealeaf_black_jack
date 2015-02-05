require_relative './card'

class Player
  module Interactive
    def say(text)
      puts text
    end
    def draw?
      say 'Draw a card?'
      answer = gets.chomp.upcase.start_with? 'Y'
      if !answer
        say 'You stay.'
      end
      answer
    end
  end
  include Interactive

  attr_accessor :name
  attr_accessor :cards

  def initialize(name)
    @name = name
  end

  def draw(card)
    @cards = [] if @cards.nil?
    @cards << card
  end

  def drawn_cards_as_str
    str = ''
    @cards.each do |c|
      str << " [ #{c.type} ] "
    end
    str
  end

  def total
    return 0 if @cards.nil?
    total = 0
    @cards.each do |c|
      total += c.value
    end
    total
  end
end