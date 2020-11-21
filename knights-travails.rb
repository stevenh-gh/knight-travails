require 'set'
require 'pry'

class Node
  attr_accessor :value, :adjacency_list, :visited, :distance, :path
  def initialize(value)
    @value = value
    @adjacency_list = Set.new
    @distance = 0
    @path = []
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

  def traverse(start, dest)
    # remove ele from front: shift
    visited = [start]
    queue = piece_move_one_step_from start
    until queue.empty?
      processed_node = queue.shift
      visited << processed_node.value unless visited.include? processed_node.value
      possible_steps = piece_move_one_step_from processed_node.value
      possible_steps.select! do |node|
        !visited.include?(node.value) && !queue.include?(node)
      end
      possible_steps.each do |node|
        node.path << processed_node.value
        node.distance = processed_node.distance + 1
      end
      queue += possible_steps
    end
    backtrack = [dest]
    step = board[dest].path[0]
    until step.nil?
      backtrack << step
      step = board[step].path[0]
    end
    backtrack << start
    backtrack.reverse
  end

  def knight_moves(start, dest)
    path = traverse start, dest
    dist = board[dest].distance + 1
    puts "You made it in #{dist} moves! Here's your path:"
    path.each { |coord| print coord; puts }
  end
end

# print coordinates
# b = Board.new
# (0..7).each do |x|
#   (0..7).each do |y|
#     print b.board[[x, y]].value
#   end
#   puts
# end
k = Knight.new
s = k.knight_moves([7, 7], [7, 6])
