module Drawable
  attr_accessor :cards
  def draw(card)
    @cards = [] if @cards.nil?
    @cards << card
  end
end