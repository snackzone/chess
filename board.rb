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
    unless self[start].moves.include?(end_pos)
      raise MoveError
    end

    #creates infinite loop here
    # raise CheckError if moving_into_check?(start, end_pos)

    return nil if start == end_pos
    selected_piece = self[start]
    selected_piece.moved = true if selected_piece.is_a?(Pawn)
    self[end_pos] = selected_piece
    selected_piece.pos = end_pos
    self[start] = nil
  end

  def moving_into_check?(start, end_pos)
    test_board = dup_board
    test_board.mark(start, end_pos)
    test_board.checked?(self[end_pos].color)
  end

  def checked?(color)
    king_pos = find_king(color)

    grid.flatten.any? do |piece|
      if piece.is_a?(Piece) && piece.pos != king_pos
        piece.moves.include?(king_pos)
      end
    end
  end

  def checkmate?(player)
    return false unless checked?(player.color)

    color_pieces = grid.flatten.select do |piece|
      piece.is_a?(Piece) && piece.color == current_player.color
    end

    color_pieces.all? do |piece|
      moves = piece.moves
      moves.all? do |move|
        test_board = dup_board
        test_board.mark(piece.pos, move)
        test_board.checked?(piece.color)
      end
    end
  end

  def dup_board
    duped_board = Board.new

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, piece_idx|
        next if piece.nil?
        opts = { color: piece.color, pos: piece.pos, board: duped_board }
        duped_piece = piece.class.new(opts)
        duped_board[[row_idx, piece_idx]] = duped_piece
      end
    end

    duped_board
  end

  def find_king(color)
    king = grid.flatten.find do |piece|
      piece.is_a?(King) && piece.color == color
    end
    king.pos
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
