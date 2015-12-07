class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    new_game!
  end

  def new_game!
    grid.length.times do |i|
      grid[i].map! do |pos|
        if i < 2 || i > 5
          pos = Piece.new
        else
          pos = nil
        end
      end
    end
  end

  def move(start, end_pos)
    raise "error" unless self[end_pos].nil? && self[start].is_a?(Piece)
    self[start], self[end_pos] = self[end_pos], self[start]
  # rescue MoveError => e # OccupiedSpaceError, EmptyStart, PieceMoveError
  #   e.message
  #   retry
  end

  def [](pos)
    grid[pos.first][pos.last]
  end

  def []=(pos, val)
    self.grid[pos.first][pos.last] = val
  end
end

class Piece
  def initialize
  end

  def inspect
    "x"
  end
end

class Display
end
