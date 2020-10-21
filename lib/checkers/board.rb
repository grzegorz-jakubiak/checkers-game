# frozen_string_literal: true

module Checkers
  class Board
    extend Forwardable

    def_delegators :@board, :[], :[]=

    def initialize
      @board = set_board
    end

    private

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
        jump_moves << jump_square if within_board?(row: jump_square[0], col: jump_square[1])
      end
      jump_moves
    end

    def adjacent_squares(row:, col:, player:)
      possible_squares(row: row, col: col, player: player) { |square| within_board?(row: square[0], col: square[1]) }
    end

    def basic_moves(row:, col:, player:)
      possible_squares(row: row, col: col, player: player) { |square| move?(row: square[0], col: square[1]) }
    end

    def possible_squares(row:, col:, player:, &block)
      if player == :human
        [[row - 1, col + 1], [row - 1, col - 1]].select(&block)
      else
        [[row + 1, col + 1], [row + 1, col - 1]].select(&block)
      end
    end

    def move?(row:, col:)
      within_board?(row: row, col: col) && square_empty?(row: row, col: col)
    end

    def within_board?(row:, col:)
      row <= 7 && row >= 0 && col <=7 && col >= 0
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
