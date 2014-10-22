module DrawAbility
  attr_accessor :cards

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
end