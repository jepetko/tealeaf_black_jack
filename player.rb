require './drawable'
require './card'

class Player
  include Drawable
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end