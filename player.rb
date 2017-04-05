require_relative 'cursor'

class HumanPlayer

  def initialize(name, color, cursor, board)
    @name = name
    @color = color
    @cursor = cursor
    @board = board
  end

  def play_turn
    start_pos = @cursor.get_input
    end_pos = @cursor.get_input
    @board.move_piece(start_pos, end_pos)
  end

end
