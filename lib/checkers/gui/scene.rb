# frozen_string_literal: true

module Checkers
  module GUI
    class Scene
      def initialize(state)
        @state = state
        @board = Board.new(state)
        @allowed_squares = []
        @allowed_moves = []
      end

      def handle_click(x, y)
        row, col = click_board_indices(x, y)

        if piece_clicked?(x, y)
          @allowed_moves = @state.board.find_available_moves(row: row, col: col, player: :human)
          @allowed_squares = @allowed_moves.map { |move| @board.square_at(*move.end_square) }
        else
          return if @allowed_squares.empty? && @allowed_moves.empty?

          move_made = @allowed_moves.find { |move| move.end_square == [row, col] }
          new_board = Checkers::Board.make_move(@state.board, move_made)
          @state.set_state(board: new_board, turn: :ai)
        end
      end

      private

      def piece_clicked?(x, y)
        @board.any? { |objects| objects.any? { _1.contains?(x, y) && _1.is_a?(Circle) } }
      end

      def click_board_indices(x, y)
        @board.find_index do |objects|
          objects.any? { _1.contains?(x, y) }
        end
      end
    end
  end
end
