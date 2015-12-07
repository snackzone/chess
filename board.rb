class Board
  PIECES = [

  ]

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    new_game!
  end

  def new_game!
    grid.map!.with_index do |row, i|
      case i
      when 0
        # pos = SlidingPiece.new(color: :black, pos: [i, j], board: self)
        place_pieces(i, :black)
      when 1
        place_pawns(i, :black)
      when 6
        place_pawns(i, :white)
      when 7
        place_pieces(i, :black)
      else
        row
      end
    end
  end

  def place_pieces(i, color)
    row = grid[i].map.with_index do |pos, j|
      case j
      when 0, 7
        pos = Rook.new(color: color)
      when 1, 6
        pos = Knight.new(color: color)
      when 2, 5
        pos = Bishop.new(color: color)
      when 3
        pos = Queen.new(color: color)
      when 4
        pos = King.new(color: color)
      end
    end

    color == :white ? row.reverse! : row
  end

  def place_pawns(i, color)
    grid[i].map { |pos| pos = Pawn.new(color: color) }
  end


  def mark(start, end_pos)
    raise "error" unless self[end_pos].nil? && self[start].is_a?(Piece)
    self[start], self[end_pos] = self[end_pos], self[start]
  # rescue MoveError => e # OccupiedSpaceError, EmptyStart, PieceMoveError
  #   e.message
  #   retry
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def [](pos)
    grid[pos.first][pos.last]
  end

  def []=(pos, val)
    self.grid[pos.first][pos.last] = val
  end
end
