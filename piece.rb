class Piece
  attr_reader :color, :board
  attr_accessor :pos

  def initialize(opts = {})
    @color = opts[:color]
    @pos = opts[:pos]
    @board = opts[:board]
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
    find_horizontal_moves(board.grid, pos)
      .concat(find_vertical_moves)
  end

  def find_vertical_moves
    find_horizontal_moves(board.grid.transpose, pos.reverse).map(&:reverse!)
  end

  def find_horizontal_moves(grid, pos)
    x, y = pos
    result = [pos]
    (y - 1).downto(0).each do |j|
      break if j < 0
      if grid[x][j].is_a?(Piece)
        result << [x, j] unless grid[x][j].color == color
        break
      else
        result << [x, j]
      end
    end

    (y + 1...8).each do |j|
      break if j > 7
      if grid[x][j].is_a?(Piece)
        result << [x, j] unless grid[x][j].color == color
        break
      else
        result << [x, j]
      end
    end
    result
  end

  def find_diagonal_moves
    x, y = pos
    result = [pos]

    (1..7).each do |i|
      break if x == 7
      if board[[x + i,  y - i]].is_a?(Piece)
        result << [x + i, y - i] unless board[[x + i,  y - i]].color == color
        break
      else
        result << [x + i, y - i]
      end
    end

    (1..7).each do |i|
      break if x == 7
      if board[[x + i, y + i]].is_a?(Piece)
        result << [x + i, y +  i] unless board[[x + i, y + i]].color == color
        break
      else
        result << [x + i, y +  i]
      end
    end

    (1..7).each do |i|
      break if x == 0
      if board[[x - i, y + i]].is_a?(Piece)
        result << [x - i, y + i] unless board[[x - i, y + i]].color == color
        break
      else
        result << [x - i, y + i]
      end
    end

    (1..7).each do |i|
      break if x == 0
      if board[[x - i, y - i]].is_a?(Piece)
        result << [x - i, y - i] unless board[[x - i, y - i]].color == color
        break
      else
        result << [x - i, y - i]
      end
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
    "♝"
  end
end

class Rook < SlidingPiece
  def moves
    potential_moves = super
    potential_moves[:cardinal]
  end

  def to_s
    "♜"
  end
end

class Queen < SlidingPiece
  def moves
    potential_moves = super
    potential_moves[:cardinal].concat(potential_moves[:diagonal])
  end

  def to_s
    "♛"
  end
end

class SteppingPiece < Piece
end

class Pawn < Piece
  def initialize(opts)
    super(opts)
    @moved = false
  end

  def moves

  end

  def to_s
    "♟"
  end
end

class Knight < SteppingPiece

  MOVES = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def to_s
    "♞"
  end

  def moves
    valid_moves = []

    cur_x, cur_y = pos
    MOVES.each do |(dx, dy)|
      new_pos = [cur_x + dx, cur_y + dy]

      if new_pos.all? { |coord| coord.between?(0, 7) }
        if board[new_pos].is_a?(Piece)
          valid_moves << new_pos unless board[new_pos].color == color
        else
          valid_moves << new_pos
        end
      end
    end

    p valid_moves
    valid_moves
  end
end

class King < SteppingPiece
  MOVES = [
    [-1, -1],
    [-1, 1],
    [-1, 0],
    [0, -1],
    [1, 0],
    [0, 1],
    [1, -1],
    [1, 1]
  ]

  def to_s
    "♚"
  end

  def moves
    valid_moves = []

    cur_x, cur_y = pos
    MOVES.each do |(dx, dy)|
      new_pos = [cur_x + dx, cur_y + dy]

      if new_pos.all? { |coord| coord.between?(0, 7) }
        if board[new_pos].is_a?(Piece)
          valid_moves << new_pos unless board[new_pos].color == color
        else
          valid_moves << new_pos
        end
      end
    end
    p valid_moves
    valid_moves
  end
end
