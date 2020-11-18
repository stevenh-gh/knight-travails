require 'set'
require 'pry'

class Node
  attr_accessor :value, :adjacency_list
  def initialize(value)
    @value = value
    @adjacency_list = Set.new
  end
end

class Board
  attr_accessor :board
  def initialize
    @board = {}
    set_board
  end

  def set_board
    (0..7).each do |x|
      (0..7).each do |y|
        n = Node.new [x, y]
        board[[x, y]] = n
      end
    end
    set_adjacency_list
  end

  def set_adjacency_list
    board.each do |key, value|
      top = [key[0] - 1, key[1]]
      down = [key[0] + 1, key[1]]
      left = [key[0], key[1] - 1]
      right = [key[0], key[1] + 1]
      [top, down, left, right].each do |coord|
        value.adjacency_list.add coord if board.has_key? coord
      end
    end
  end
end

b = Board.new
b.board.each_value do |ele|
  print "node: #{ele.value}, list: #{ele.adjacency_list}"
  puts
end
