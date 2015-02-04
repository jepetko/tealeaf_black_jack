require_relative './player'
require_relative './give_ability'

class Dealer < Player
  include GiveAbility
end