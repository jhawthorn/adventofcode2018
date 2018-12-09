require 'set'
require 'time'

class Marble
  attr_accessor :n, :left, :right

  def initialize(n, left = self, right = self)
    @n = n
    @left = left
    @right = right
  end

  def insert(n)
    marble = Marble.new(n, self, @right)
    @right.left = marble
    @right = marble
    marble
  end

  def remove
    @right.left = @left
    @left.right = @right
    @right
  end

  def to_a
    array = [n]
    marble = @right
    while marble != self
      array << marble.n
      marble = marble.right
    end
    array
  end
end

def calculate(top, players)
  marble = Marble.new(0)
  players = [0] * players

  1.upto(top) do |n|
    if n % 23 == 0
      marble = marble.left.left.left.left.left.left.left
      players[(n - 1) % players.size] += marble.n + n
      marble = marble.remove
    else
      marble = marble.right.insert(n)
    end
  end

  players.max
end

raise unless calculate(25, 9) == 32
raise unless calculate(1618, 10) == 8317

p calculate(71082, 413)
p calculate(7108200, 413)
