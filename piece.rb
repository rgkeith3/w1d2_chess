require 'singleton'
require 'byebug'

class Piece
  attr_reader :symbol, :color

  attr_accessor :pos

  def initialize(pos, board, color)
    @moves = []
    @pos = pos
    @board = board
    @color = color
  end

  def valid_moves
    valid_moves = []
    moves.each do |move|
      valid_moves << move unless @board.moves_into_check?(@pos, move)
    end
    valid_moves
  end

end

class NullPiece < Piece
  include Singleton
  def initialize
    @symbol = :_
    @color = :none
    @pos = []
  end
end

MOVES = {
  west: [0, -1],
  east: [0, 1],
  north: [-1, 0],
  south: [1, 0],
  nw: [-1, -1],
  ne: [-1, 1],
  sw: [1, -1],
  se: [1, 1]
}

module SlidingPiece

  def moves
    poss_moves = []
    @move_dirs.each do |el|
      poss_moves.concat(moves_in_dir(el))
    end
    poss_moves
  end

  def moves_in_dir(dir)
    poss_moves = []
    next_pos = next_move(@pos, dir)
    while @board.in_bounds?(next_pos)
      if @board[next_pos].color == :none
        poss_moves << next_pos
        next_pos = next_move(next_pos, dir)
      elsif (@board[next_pos].color != :none) && (@board[next_pos].color != @color)
        poss_moves << next_pos
        break
      else
        break
      end
    end
    poss_moves
  end

  def next_move(pos, dir)
    [pos[0] + MOVES[dir][0], pos[1] + MOVES[dir][1]]
  end

end

module SteppingPiece

  def moves
    poss_moves = []
    move_dirs.each do |dir|
      next_pos = next_move(@pos, dir)
      if @board.in_bounds?(next_pos) && @board[next_pos].color != @color
        poss_moves << next_pos
      end
    end
    poss_moves
  end

  def next_move(pos, dir)
    [pos[0] + MOVES[dir][0], pos[1] + MOVES[dir][1]]
  end
end

class Queen < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :q
    super
    @move_dirs = [:west, :east, :north, :south, :ne, :nw, :se, :sw]
  end

end

class King < Piece
  include SteppingPiece

  def initialize(pos, board, color)
    @symbol = :Z
    super
  end

  def move_dirs
    [:west, :east, :north, :south, :ne, :nw, :se, :sw]
  end
end

class Bishop < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :b
    super
    @move_dirs = [:ne, :nw, :se, :sw]
  end
end

class Rook < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :r
    super
    @move_dirs = [:west, :east, :north, :south]
  end
end

class Knight < Piece

  KNIGHT_MOVES = [
    [2, 1],
    [-2, 1],
    [-2, -1],
    [2, -1],
    [1, 2],
    [1, -2],
    [-1, 2],
    [-1, -2]
  ]

  def initialize(pos, board, color)
    @symbol = :k
    super
  end

  def moves
    poss_moves = []
    KNIGHT_MOVES.each do |move|
      next_pos = next_move(@pos, move)
      poss_moves << next_pos if valid_knight_move?(next_pos)
    end
    poss_moves
  end

  def next_move(pos, move)
    [pos[0] + move[0], pos[1] + move[1]]
  end

  def valid_knight_move?(next_pos)
    @board.in_bounds?(next_pos) && @board[next_pos].color != @color
  end

end

class Pawn < Piece
  attr_accessor :first_move

  def initialize(pos, board, color)
    @symbol = :p
    @first_move = true
    super
  end



  def moves
    poss_moves = []
    if @color == :black
      poss_moves << next_move(@pos, [1, 0]) if @board[next_move(@pos, [1,0])] == NullPiece.instance
      unless @board[next_move(@pos, [2,0])].color == :blue
        poss_moves << next_move(@pos, [2, 0]) if @first_move
      end
      if @board.in_bounds?(next_move(@pos, [1, 1])) &&
        @board[next_move(@pos, [1, 1])].color == :blue
          poss_moves << next_move(@pos, [1, 1])
      elsif @board.in_bounds?(next_move(@pos, [1, -1])) &&
        @board[next_move(@pos, [1, -1])].color == :blue
        poss_moves << next_move(@pos, [1, -1])
      end
    else
      poss_moves << next_move(@pos, [-1, 0]) if @board[next_move(@pos, [1,0])] == NullPiece.instance
      unless @board[next_move(@pos, [-2,0])].color == :black
        poss_moves << next_move(@pos, [-2, 0]) if @first_move
      end
      if @board.in_bounds?(next_move(@pos, [-1, 1])) &&
        @board[next_move(@pos, [-1, 1])].color == :black
        poss_moves << next_move(@pos, [-1, 1])
      elsif @board.in_bounds?(next_move(@pos, [-1, -1])) &&
        @board[next_move(@pos, [-1, -1])].color == :black
        poss_moves << next_move(@pos, [-1, -1])
      end
    end
    poss_moves
  end

  def next_move(pos, move)
    [pos[0] + move[0], pos[1] + move[1]]
  end

end
