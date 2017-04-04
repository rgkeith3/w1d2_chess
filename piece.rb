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

  def moves
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

KNIGHT_MOVES = {
  [[2, 1],
  [-2, 1],
  [-2, -1],
  [2, -1],
  [1, 2],
  [1, -2],
  [-1, 2],
  [-1, -2]]
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
      poss_moves << next_pos if @board.in_bounds?(next_pos)
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
  end

  def move_dirs
    [:ne, :nw, :se, :sw]
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

  @knight_moves = [[2, 1],
  [-2, 1],
  [-2, -1],
  [2, -1],
  [1, 2],
  [1, -2],
  [-1, 2],
  [-1, -2]]

  def initialize(pos, board, color)
    @symbol = :k
    super
  end

  def moves
    poss_moves = []
    @knight_moves.each do |move|
      next_pos = next_move(@pos, move)
      poss_moves << next_pos if @board.in_bounds?(next_pos)
    end
  end


    def next_move(pos, move)
      [pos[0] + move[0], pos[1] + move[1]]
    end

end

class Pawn < Piece
  include SteppingPiece

  def initialize(pos, board, color)
    @symbol = :p
    super
  end

  def move_dirs

  end
end
