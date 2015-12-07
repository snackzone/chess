class Piece
  attr_reader :color, :pos, :board

  def initialize(opts = {})
    @color = opts[:color]
    @pos = opts[:pos]
    @board = opts[:board]
  end

  def inspect
    "x"
  end

  def to_s
    "x"
  end

  def moves
    nil
  end
end

class SlidingPiece < Piece
  def moves
    potential_moves = {
      cardinal: find_cardinal_moves,
      diagonal: find_diagonal_moves
    }
  end

  def find_cardinal_moves
    result = []
    x, y = pos

    i = 1
    until board[[x, y - i]].is_a?(Piece) || y - i < 0
      result << [x, y - i]
      i += 1
    end

    i = 1
    until board[[x, y + i]].is_a?(Piece) || y + i > 7
      result << [x, y +  i]
      i += 1
    end

    i = 1
    until board[[x - i, y]].is_a?(Piece) || x - i < 0
      result << [x - i, y]
      i += 1
    end

    i = 1
    until board[[x + i, y]].is_a?(Piece) || x + i > 7
      result << [x + i, y]
      i += 1
    end

    result
  end

  def find_diagonal_moves
    x, y = pos
    result = []

    (1..7).each do |i|
      break if board[[x + i, y - i]].is_a?(Piece)
      result << [x + i, y - i]
    end

    (1..7).each do |i|
      break if board[[x + i, y + i]].is_a?(Piece)
      result << [x + i, y +  i]
    end

    (1..7).each do |i|
      break if board[[x - i, y + i]].is_a?(Piece)
      result << [x - i, y + i]
    end

    (1..7).each do |i|
      break if board[[x - i, y - i]].is_a?(Piece)
      result << [x - i, y - i]
    end

    result.select { |pos| board.in_bounds?(pos) }
  end
end

class Bishop < SlidingPiece
  def moves
    potential_moves = super
    potential_moves[:diagonal]
  end

  def to_s
    "B"
  end
end

class Rook < SlidingPiece
  def moves
    potential_moves = super
    potential_moves[:cardinal]
  end

  def to_s
    "R"
  end
end

class Queen < SlidingPiece
  def moves
    potential_moves = super
    potential_moves[:cardinal].concat(potential_moves[:diagonal])
  end

  def to_s
    "Q"
  end
end

class SteppingPiece < Piece
end

class Pawn < Piece
  def to_s
    "P"
  end
end

class Knight < SteppingPiece
  def to_s
    "N"
  end
end

class King < SteppingPiece
  def to_s
    "K"
  end
end
