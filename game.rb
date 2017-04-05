require_relative 'board'
require_relative 'player'
require_relative 'display'

class Game

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @player1 = HumanPlayer.new("player1", :blue, @display.cursor, @board)
    @player2 = HumanPlayer.new("player2", :black, @display.cursor, @board)
  end

  def play
    @current_player = @player1
    until over?
      @display.render
      @current_player.play_turn
      switch_player
    end
  end

  def switch_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def over?
    return true if @board.checkmate?(:blue) || @board.checkmate?(:black)
    false
  end

end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end
