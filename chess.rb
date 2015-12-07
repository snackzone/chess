require_relative "display"
require_relative "board"
require_relative "piece"
require_relative "player"

class Chess
  attr_accessor :board, :display, :selected, :players

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = [Player.new(:white), Player.new(:black)]
  end

  def current_player
    players.first
  end

  def switch_players!
    players.rotate!
  end

  # rescue errors here
  def play
    start_pos, end_pos = move
    board.mark(start_pos, end_pos) # let mark "raise" errors
    # switch!
  end


  def move
    result = []
    until result.length == 2
      display.render
      move = display.get_input
      result << move if move.is_a?(Array)
    end

    result # raise an error if result.first is not the right color
  end


end
