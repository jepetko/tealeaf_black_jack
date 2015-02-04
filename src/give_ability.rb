module GiveAbility
  def give(card_stack)
    return nil if card_stack.nil?
    return nil if card_stack.stack.empty?
    card_stack.stack.pop
  end
end