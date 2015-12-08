require_relative "display"
require_relative "board"
require_relative "piece"
require_relative "player"
require_relative "error"
require 'byebug'

class Chess
  attr_accessor :board, :display, :first_selected, :second_selected, :players

  def initialize
    @board = Board.new
    @display = Display.new(@board, self)
    @players = [Player.new(:white), Player.new(:black)]
    @first_selected, @second_selected = nil
    @board.new_game!
  end

  def current_player
    players.first
  end

  def other_player
    players.last
  end

  def switch_players!
    players.rotate!
  end

  def play
    until over?
      begin
        move
      rescue MoveError => e
        self.first_selected, self.second_selected = nil
        puts e.message
        sleep(1)
        retry
      end
      switch_players!
    end
  end

  def over?
    false
  end

  def move
    display.render
    case display.get_input
    when :save
      save
    when :return
      selected_pos = display.cursor_pos
      if first_selected
        self.second_selected = selected_pos
        if first_selected == second_selected
          self.first_selected, self.second_selected = nil
          move
        else
          board.mark(first_selected, second_selected) if valid_move?
          self.first_selected, self.second_selected = nil
        end
      else
        self.first_selected = selected_pos if board[selected_pos].is_a?(Piece) &&
          board[selected_pos].color == current_player.color
        move
      end
    else
      move
    end
  end

  def valid_move?
    test_board = dup_board
    raise MoveError unless board[first_selected].moves.include?(second_selected)
    test_board.mark(first_selected, second_selected)
    debugger if test_board.checked?(current_player.color)
    raise CheckError if test_board.checked?(current_player.color)
    true
  end

  def dup_board
    duped_board = Board.new

    board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, piece_idx|
        if piece.nil?
          next
        else
          duped_piece = piece.class.new(color: piece.color, pos: piece.pos, board: duped_board)
          duped_board[[row_idx, piece_idx]] = duped_piece
        end
      end
    end

    duped_board
  end

  def save
    puts "game saved!"
  end
end
