module Giveable
  def give(stack)
    return nil if stack.empty?
    stack.pop
  end
end