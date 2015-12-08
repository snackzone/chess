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
    @display = Display.new(@board)
    @players = [Player.new(:white), Player.new(:black)]
    @first_selected, @second_selected = nil
  end

  def current_player
    players.first
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
        p "second: #{second_selected}"
        board.mark(first_selected, second_selected) if valid_move?
        self.first_selected, self.second_selected = nil
      else
        self.first_selected = selected_pos if board[selected_pos].is_a?(Piece) &&
          board[selected_pos].color == current_player.color
        p "first: #{first_selected}"
        move
      end
    else
      move
    end
  end

  def valid_move?
    raise MoveError unless board[first_selected].moves.include?(second_selected)
    # test_board = dup_board
    # test_board.mark(first_selected, second_selected)
    # raise CheckError if test_board.checked?
    true
  end

  def save
    puts "game saved!"
  end
end
