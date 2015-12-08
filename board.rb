class Board
  attr_accessor :grid

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
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
    selected_piece = self[start]
    selected_piece.moved = true if selected_piece.is_a?(Pawn)
    self[end_pos] = selected_piece
    selected_piece.pos = end_pos
    self[start] = nil
  end

  def checked?(color)
    king_pos = find_king(color)

    grid.flatten.any? do |piece|
      if piece.is_a?(Piece) && piece.pos != king_pos
        piece.moves.include?(king_pos)
      end
    end
  end

  # def checkmate?(color)
  #   king_pos = find_king(color)
  # end

  def find_king(color)
    grid.flatten.find do |piece|
      piece.is_a?(King) && piece.color == color
    end.pos
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

  def inspect
    Display.new(self).render
  end
end
