require 'set'
require 'pry'

class Node
  attr_accessor :value, :adjacency_list, :visited
  def initialize(value)
    @value = value
    @adjacency_list = Set.new
    @visited = false
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

class Knight
  attr_accessor :board
  def initialize
    @board = Board.new.board
  end

  def piece_move_one_step_from(start)
    return nil unless board.has_key? start

    x = start[0]
    y = start[1]
    up_left = [x - 2, y - 1]
    up_right = [x - 2, y + 1]
    down_left = [x + 2, y - 1]
    down_right = [x + 2, y + 1]
    left_up = [x - 1, y - 2]
    left_down = [x + 1, y - 2]
    right_up = [x - 1, y + 2]
    right_down = [x + 1, y + 2]
    destinations = []
    [up_left, up_right, down_left, down_right, left_up, left_down, right_up, right_down].each do |coord|
      destinations << coord if board.has_key? coord
    end
    destinations.map! { |coord| coord = board[coord] }.uniq!
    destinations
  end

  def knight_moves(start, dest)
    # remove ele from front: shift
    board[start].visited = true
    steps = [start]
    queue = piece_move_one_step_from start
    until queue.empty?
      processed_node = queue.shift
      steps << processed_node.value unless processed_node.visited
      processed_node.visited = true
      break if processed_node.value == dest

      queue += piece_move_one_step_from processed_node.value
    end
    steps
  end
end

b = Board.new
(0..7).each do |x|
  (0..7).each do |y|
    print b.board[[x, y]].value
  end
  puts
end
# b.board.each_value do |ele|
#   print "node: #{ele.value}, list: #{ele.adjacency_list}"
#   puts
# end
k = Knight.new
# p k.piece_move_one_step_from([0, 0])
s = k.knight_moves([0, 0], [7, 7])
s.each { |s| p s; puts }
