require './card'

class CardStack
  BASIC_STACK = []

  attr_accessor :stack

  protected
  def initialize_basic_stack
    if BASIC_STACK.empty?
      (2..10).each do |n|
        BASIC_STACK << Card.new(n)
      end
      BASIC_STACK << Card.new('Jack',10)
      BASIC_STACK << Card.new('Queen',10)
      BASIC_STACK << Card.new('King',10)
      BASIC_STACK << Card.new('Ace',11)
    end
  end

  public
  def initialize(packages_count=1)
    packages_count.times { self.initialize_basic_stack }
    self.stack = BASIC_STACK.shuffle
  end
end