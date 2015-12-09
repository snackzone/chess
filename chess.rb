require_relative 'display'
require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'error'
require 'byebug'
require 'yaml'

class Chess
  def self.load_game
    puts "loading saved game..."
    sleep(1)

    loaded_game = YAML.load_file("SAVED_GAME.yml")
    loaded_game.play
  end

  attr_accessor :board, :display, :first_selected, :second_selected, :players

  def initialize
    @board = Board.new
    @display = Display.new(@board, self)
    @players = [Player.new(:white), Player.new(:black)]
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
    take_turn until board.checkmate?(current_player)

    display.render
    puts "Checkmate!"
    puts "#{other_player.color} wins!"
  end

  def take_turn
    display.render
    case display.get_input
    when :save
      save
      switch_players!
    when :return
      if first_selected
        make_second_selection
      else
        make_first_selection
      end
    else
      take_turn
    end
  end

  def make_first_selection
    selected_pos = display.cursor_pos
    if board[selected_pos].is_a?(Piece) &&
       (board[selected_pos].color == current_player.color)
      self.first_selected = selected_pos
    end

    take_turn
  end

  def make_second_selection
    self.second_selected = display.cursor_pos
    make_move
  end

  def reset_selections!
    self.first_selected, self.second_selected = nil
  end

  def make_move
    switch_players! if first_selected == second_selected
    
    if board.moving_into_check?(first_selected, second_selected)
      raise CheckError
    end

    board.mark(first_selected, second_selected)
  rescue MoveError => e
    puts e.message
    sleep(1)
    switch_players!
  ensure
    reset_selections!
    switch_players!
  end

  def save
    File.write('SAVED_GAME.yml', to_yaml)
  end
end

if __FILE__ == $PROGRAM_NAME
  puts 'enter NEW or LOAD.'
  input = gets.chomp.downcase

  input == 'load' ? Chess.load_game : Chess.new.play
end
