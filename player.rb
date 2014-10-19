class Player
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def draw

  end
end

p = Player.new 'Hugo'
puts p.name