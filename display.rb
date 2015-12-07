require 'colorize'
require 'byebug'
require_relative 'cursorable'

class Display
  include Cursorable
  attr_accessor :board, :game, :cursor_pos, :selected

  def initialize(board, game=nil)
    @board = board
    @game = game
    @cursor_pos = [0, 0]
    @selected = false
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

  #change nil to render a " " here.
  def colors_for(i, j)
    if [i, j] == cursor_pos
      bg = :yellow
    elsif (i + j).even?
      bg = :light_white
    elsif (i + j).odd?
      bg = :light_black
    end

    if board[[i, j]].is_a?(Piece)
      color = :black
      # board[[i, j]].color
    end

    { background: bg, color: :black }
  end

  def render
    system("clear")
    build_grid.each { |row| puts row.join }
    nil
  end
end
