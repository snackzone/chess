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
  DIAG_MOVES = [
            [1, 1],
            [1, -1],
            [-1, 1],
            [-1, -1]
          ]

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
    cur_x, cur_y = pos
    result = [pos]

    DIAG_MOVES.each do |dx, dy|
      new_pos = [cur_x, cur_y]
      new_pos = [new_pos.first + dx, new_pos.last + dy]

      while board.in_bounds?(new_pos)
        if board[new_pos].is_a?(Piece)
          result << new_pos unless board[new_pos].color == color
          break
        else
          result << new_pos
        end

        new_pos = [new_pos.first + dx, new_pos.last + dy]
      end
    end

    result
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
  attr_accessor :moved

  def initialize(opts)
    super(opts)
    @moved = false
  end

  MOVES = {
            black_moves:   [[1, 0], [2, 0]],
            black_attacks: [[1 , -1],[1, 1]],
            white_moves:   [[-1, 0],[-2, 0]],
            white_attacks: [[-1 , -1],[-1, 1]]
          }
  #map each coordinate * 1 for white moves.

  def moves
    if color == :black
      find_moves(MOVES[:black_moves]) +
      find_attacks(MOVES[:black_attacks])
    else
      find_moves(MOVES[:white_moves]) +
      find_attacks(MOVES[:white_attacks])
    end
  end

  def find_moves(moves)
    cur_x, cur_y = pos
    valid_moves = [pos]

    new_pos = [cur_x + moves.first[0], cur_y + moves.first[1]]
    if board[new_pos].nil?
      valid_moves << new_pos
      double_move = [cur_x + moves.last[0], cur_y + moves.last[1]]
      valid_moves << double_move if board[double_move].nil? && moved == false
    end

    valid_moves
  end

  def find_attacks(attacks)
    cur_x, cur_y = pos
    valid_moves = []

    attacks.each do |(dx, dy)|
      new_pos = [cur_x + dx, cur_y + dy]
      if new_pos.all? { |coord| coord.between?(0, 7) }
        if board[new_pos].is_a?(Piece)
          valid_moves << new_pos unless board[new_pos].color == color
        end
      end
    end

    valid_moves
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
    valid_moves = [pos]

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
    valid_moves = [pos]

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

    valid_moves
  end
end
