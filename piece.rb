require 'singleton'

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

module SlidingPiece

  def moves(move_dirs)
    poss_moves = []
    move_dirs.each do |el|
      moves_in_dir(el)
    end
  end

  def moves_in_dir(dir)
    
  end

end

module SteppingPiece

  def moves(move_dirs)

  end

end

class Queen < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    @symbol = :q
    super
  end

  def move_dirs
    [:west, :east, :north, :south, :ne, :nw, :se, :sw]
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
  end

  def move_dirs
    [:west, :east, :north, :south]
  end
end

class Knight < Piece
  include SteppingPiece

  def initialize(pos, board, color)
    @symbol = :k
    super
  end

  def move_dirs
    [:knight]
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
