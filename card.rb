class Card
  attr_accessor :type
  attr_accessor :value
  def initialize(type,value=type)
    self.type = type
    self.value = value
  end
end



p Card.new 'Jack', 10
p Card.new 3