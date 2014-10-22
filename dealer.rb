require './player'
require './give_ability'

class Dealer < Player
  include GiveAbility
end