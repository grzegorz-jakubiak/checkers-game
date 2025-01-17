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

    attr_reader :board, :jumped, :last_move

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

        new_board[*move.end_square] = if move.end_square[0].zero? && new_board[*move.start_square] == HUMAN_PIECE
                                        HUMAN_KING
                                      elsif move.end_square[0] == 7 && new_board[*move.start_square] == AI_PIECE
                                        AI_KING
                                      else
                                        new_board[*move.start_square]
                                      end
        new_board[*move.start_square] = 0

        if move.is_a?(JumpMove)
          new_board[*move.jump_over_square] = 0
          jumped = true
        end
        Board.new(board: new_board, jumped: jumped, last_move: move)
      end
    end

    def initialize(board: nil, jumped: false, last_move: nil)
      @board = board || set_board
      @jumped = jumped
      @last_move = last_move
    end

    def calculate_score(player:)
      number_of_pieces(player: player) +
        number_of_pieces_on_opponets_side(player: player) +
        3 * movable_pieces(player: player) +
        4 * number_of_unoccupied_promotion_squares(player: player)
    end

    def count_pieces(player:)
      board.count { |piece| player_pieces(player).include?(piece) }
    end

    def find_moves_for_player(player:)
      found_moves = []
      @board.each_with_index do |e, row, col|
        next unless player_pieces(player).include?(e)

        moves = find_available_moves(row: row, col: col, player: player)
        found_moves += moves
        break found_moves = moves if moves.any? { |move| move.is_a?(JumpMove) }
      end
      found_moves
    end

    def any_jump_moves?(player:)
      find_moves_for_player(player: player).one? { |move| move.is_a?(JumpMove) }
    end

    protected

    def player_pieces(player)
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
      move_up = [[row - 1, col + 1], [row - 1, col - 1]]
      move_down = [[row + 1, col + 1], [row + 1, col - 1]]
      if player == :human
        if @board[row, col] == HUMAN_PIECE
          yield move_up
        else
          yield(move_up + move_down)
        end
      else
        if @board[row, col] == AI_PIECE
          yield move_down
        else
          yield(move_down + move_up)
        end
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
