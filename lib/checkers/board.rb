# frozen_string_literal: true

module Checkers
  class Board
    include Score

    attr_reader :board, :jumped

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

        if move.is_a?(Checkers::JumpMove)
          new_board[*move.end_square] = new_board[*move.start_square]
          new_board[*move.start_square] = :empty
          new_board[*move.jump_over_square] = :empty
          jumped = true
        else
          new_board[*move.end_square] = new_board[*move.start_square]
          new_board[*move.start_square] = :empty
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

    def find_moves_for_player(player:)
      found_moves = []
      @board.each_with_index do |e, row, col|
        next unless e == player

        moves = find_available_moves(row: row, col: col, player: player)
        found_moves += moves
        break found_moves = moves if moves.any? { |move| move.is_a?(Checkers::JumpMove) }
      end
      found_moves
    end

    protected

    def find_available_moves(row:, col:, player:)
      jumps = jump_moves(row: row, col: col, player: player)
      return jumps if jumps.any?

      basic_moves(row: row, col: col, player: player)
    end

    def jump_moves(row:, col:, player:)
      jump_moves = []
      adjacent_squares(row: row, col: col, player: player).each do |square|
        adjacent_row, adjacent_col = square
        next if [:empty, player].include?(@board[adjacent_row, adjacent_col])

        vector = [adjacent_row - row, adjacent_col - col]
        jump_square = [adjacent_row + vector[0], adjacent_col + vector[1]]
        if within_board?(row: jump_square[0], col: jump_square[1])
          jump_moves << Checkers::JumpMove.new([row, col], jump_square)
        end
      end
      jump_moves
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

    def basic_moves(row:, col:, player:)
      possible_squares(row: row, col: col, player: player) do |squares|
        squares.filter_map { |square| Checkers::Move.new([row, col], square) if move?(row: square[0], col: square[1]) }
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
      @board[row, col] == :empty
    end

    def set_board
      Matrix[
        %i[empty ai empty ai empty ai empty ai],
        %i[ai empty ai empty ai empty ai empty],
        %i[empty ai empty ai empty ai empty ai],
        %i[empty empty empty empty empty empty empty empty],
        %i[empty empty empty empty empty empty empty empty],
        %i[human empty human empty human empty human empty],
        %i[empty human empty human empty human empty human],
        %i[human empty human empty human empty human empty]
      ]
    end
  end
end
