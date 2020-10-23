# frozen_string_literal: true

module Checkers
  class Board
    module Moves
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
          jump_moves << JumpMove.new([row, col], jump_square) if within_board?(row: jump_square[0], col: jump_square[1])
        end
        jump_moves
      end

      def basic_moves(row:, col:, player:)
        possible_squares(row: row, col: col, player: player) do |squares|
          squares.filter_map { |square| Move.new([row, col], square) if move?(row: square[0], col: square[1]) }
        end
      end
    end
  end
end
