require_relative 'piece'

class Board
attr_reader :board

  def self.blank_board
    Array.new(8) {Array.new(8)}
  end

  def set_pieces
    self[[0,0]] = Rook.new([0,0], self, :black)
    self[[0,1]] = Knight.new([0,1], self, :black)
    self[[0,2]] = Bishop.new([0,2], self, :black)
    self[[0,3]] = Queen.new([0,3], self, :black)
    self[[0,4]] = King.new([0,4], self, :black)
    self[[0,5]] = Bishop.new([0,5], self, :black)
    self[[0,6]] = Knight.new([0,6], self, :black)
    self[[0,7]] = Rook.new([0,7], self, :black)
    @board[1].map!.with_index { |el, id| el = Pawn.new([1, id], self, :black) }

    self[[7,0]] = Rook.new([7,0], self, :blue)
    self[[7,1]] = Knight.new([7,1], self, :blue)
    self[[7,2]] = Bishop.new([7,2], self, :blue)
    self[[7,3]] = Queen.new([7,3], self, :blue)
    self[[7,4]] = King.new([7,4], self, :blue)
    self[[7,5]] = Bishop.new([7,5], self, :blue)
    self[[7,6]] = Knight.new([7,6], self, :blue)
    self[[7,7]] = Rook.new([7,7], self, :blue)
    @board[6].map!.with_index { |el, id| el = Pawn.new([6, id], self, :blue) }

    @board.each do |row|
      row.each_with_index do |el, idx|
        row[idx] = NullPiece.instance if el.nil?
      end
    end


    # @board.each_with_index do |row, idx|
    #   if [0,1,6,7].include?(idx)
    #     row.map! {|el| el = Piece.new}
    #   end
    # end
  end

  def initialize(board = Board.blank_board)
    @board = board
    set_pieces
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

  def move_piece(start_pos, end_pos)
    #gets input from player

    if self[start_pos].nil?
      raise RuntimeError.new("No piece at starting position")
    end

    #raise error if piece can't move to end_pos
    self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
    rescue
      retry
  end

  def in_bounds?(pos)
    pos.all? { |el| el.between?(0,7) }
  end

end
