# frozen_string_literal: true

module Checkers
  HUMAN_PIECE = -1
  HUMAN_KING = -2
  HUMAN_PIECES = [HUMAN_PIECE, HUMAN_KING].freeze

  AI_PIECE = 1
  AI_KING = 2
  AI_PIECES = [AI_PIECE, AI_KING].freeze

  class Board
    include Score
    include Moves
    extend Forwardable

    attr_reader :board, :jumped

    def_delegators :board, :each_with_index, :row_count

    class << self
      def generate_boards(board_object, player)
        moves = board_object.find_moves_for_player(player: player)
        moves.map do |move|
          make_move(board_object, move)
        end
      end

      def make_move(board_object, move)
        new_board = board_object.board.dup
        jumped = false

        new_board[*move.end_square] = new_board[*move.start_square]
        new_board[*move.start_square] = 0

        if move.is_a?(JumpMove)
          new_board[*move.jump_over_square] = 0
          jumped = true
        end
        Board.new(board: new_board, jumped: jumped)
      end
    end

    def initialize(board: nil, jumped: false)
      @board = board || set_board
      @jumped = jumped
    end

    def calculate_score(player:)
      number_of_pieces(player: player) +
        number_of_pieces_on_opponets_side(player: player) +
        movable_pieces(player: player)
    end

    def count_pieces(player:)
      board.count { |piece| piece == player }
    end

    def find_moves_for_player(player:)
      found_moves = []
      @board.each_with_index do |e, row, col|
        next unless pieces(player).include?(e)

        moves = find_available_moves(row: row, col: col, player: player)
        found_moves += moves
        break found_moves = moves if moves.any? { |move| move.is_a?(JumpMove) }
      end
      found_moves
    end

    protected

    def pieces(player)
      player == :human ? HUMAN_PIECES : AI_PIECES
    end

    def adjacent_squares(row:, col:, player:)
      possible_squares(row: row, col: col, player: player) do |squares|
        squares.select { |square| within_board?(row: square[0], col: square[1]) }
      end
    end

    def movable_squares(row:, col:, player:)
      possible_squares(row: row, col: col, player: player) do |squares|
        squares.select { |square| move?(row: square[0], col: square[1]) }
      end
    end

    def possible_squares(row:, col:, player:)
      if player == :human
        yield [[row - 1, col + 1], [row - 1, col - 1]]
      else
        yield [[row + 1, col + 1], [row + 1, col - 1]]
      end
    end

    private

    def move?(row:, col:)
      within_board?(row: row, col: col) && square_empty?(row: row, col: col)
    end

    def within_board?(row:, col:)
      row <= 7 && row >= 0 && col <= 7 && col >= 0
    end

    def square_empty?(row:, col:)
      @board[row, col].zero?
    end

    def set_board
      Matrix[
        [0, 1, 0, 1, 0, 1, 0, 1],
        [1, 0, 1, 0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [-1, 0, -1, 0, -1, 0, -1, 0],
        [0, -1, 0, -1, 0, -1, 0, -1],
        [-1, 0, -1, 0, -1, 0, -1, 0]
      ]
    end
  end
end
