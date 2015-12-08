require 'colorize'
require 'byebug'
require_relative 'cursorable'

class Display
  include Cursorable
  attr_accessor :board, :game, :cursor_pos

  def initialize(board, game=nil)
    @board = board
    @game = game
    @cursor_pos = [0, 0]
  end

  def build_grid
    board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece = " " if piece.nil?
      " #{piece} ".colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == cursor_pos
      bg = :yellow
    elsif (i + j).even?
      bg = :light_white
    elsif (i + j).odd?
      bg = :light_black
    end

    if board[[i, j]].is_a?(Piece)
      color = board[[i, j]].color
    end

    if game.first_selected && game.first_selected == [i, j]
      bg = :green
    end

    { background: bg, color: color }
  end

  def render
    system("clear")
    puts "#{game.current_player.color}'s turn:"
    build_grid.each { |row| puts row.join }
    nil
  end
end
