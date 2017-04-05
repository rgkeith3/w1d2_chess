require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_accessor :cursor

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    system "clear"
    @board.board.each_with_index do |row, idx|
      print "|"
      row.each_with_index do |square, index|
        if [idx, index] == @cursor.cursor_pos
          print render_square([idx, index]).colorize(:background => :red)
          print "|"
        else
          print render_square([idx, index]).colorize(:background => white_or_black([idx, index]))
          print "|"
        end
      end
      print "\n"
    end
  end

  def white_or_black(pos)
    if pos.all?(&:even?)
      return :white
    elsif pos.all?(&:odd?)
      return :white
    else
      return :grey
    end
  end

  def render_square(pos)
    @board[pos].symbol.to_s.colorize(@board[pos].color)
  end

  def navigate
    while true
      render
      @cursor.get_input
    end
  end
end

# display = Display.new(Board.new)
# display.navigate
