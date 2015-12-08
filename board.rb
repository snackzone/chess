class Board
  attr_accessor :grid

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
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
        place_pieces(i, :white)
      else
        row
      end
    end
  end

  def place_pieces(i, color)
    grid[i].map.with_index do |pos, j|
      opts = { color: color, pos: [i, j], board: self }
      case j
      when 0, 7
        pos = Rook.new(opts)
      when 1, 6
        pos = Knight.new(opts)
      when 2, 5
        pos = Bishop.new(opts)
      when 3
        pos = Queen.new(opts)
      when 4
        pos = King.new(opts)
      end
    end
  end

  def place_pawns(i, color)
    grid[i].map.with_index do |pos, j|
      opts = { color: color, pos: [i, j], board: self }
      pos = Pawn.new(opts)
    end
  end


  def mark(start, end_pos)
    debugger
    self[end_pos] = self[start]
    self[start] = nil
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
