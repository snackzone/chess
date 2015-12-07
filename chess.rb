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
    until over?
      begin
        start_pos, end_pos = move
        raise MoveError,
          "that's not your piece!" unless board[start_pos].color == current_player.color
        board.mark(start_pos, end_pos)
      rescue MoveError => e
        puts e.message
        retry
      end
      switch_players!
    end
  end

  def over?
    false
  end


  def move
    result = []
    until result.length == 2
      display.render
      move = display.get_input
      result << move if move.is_a?(Array)
      p result
    end

    result # raise an error if result.first is not the right color
  end


end


class MoveError < StandardError
  attr_accessor :message
  def initialize(message)
    @message = message
  end
end
