require './player'
require './giveable'

class Dealer < Player
  include Giveable
end