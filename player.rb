require './draw_ability'
require './card'

class Player
  include DrawAbility
  attr_accessor :name

  def initialize(name)
    @name = name
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