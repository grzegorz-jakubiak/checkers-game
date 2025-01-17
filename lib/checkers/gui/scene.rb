# frozen_string_literal: true

module Checkers
  module GUI
    class Scene
      extend Forwardable

      attr_reader :board

      def_delegators :board, :animation_queue

      def initialize(state, game_enigne)
        @state = state
        @board = Board.new(state, game_enigne)
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
          if move_made
            @allowed_moves = []
            @allowed_squares = []
            new_board = Checkers::Board.make_move(@state.board, move_made)
            turn = if new_board.jumped
                     new_board.any_jump_moves?(player: :human) ? :human : :ai
                   else
                     :ai
                   end
            @state.set_state(board: new_board, turn: turn)
          end
        end
      end

      private

      def piece_clicked?(x, y)
        @board.any? do |object|
          object.contains?(x, y) && object.is_a?(Ruby2D::SquareWithPiece) && object.player == :human
        end
      end

      def click_board_indices(x, y)
        @board.find_index do |object|
          object.contains?(x, y)
        end
      end
    end
  end
end
