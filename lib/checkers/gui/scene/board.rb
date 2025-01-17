# frozen_string_literal: true

module Checkers
  module GUI
    class Scene
      class Board
        include Enumerable

        attr_reader :animation_queue

        def initialize(state, game_engine)
          @state = state
          @state.add_observer(self)
          @game_engine = game_engine
          @animation_queue = []
          render_board
        end

        def update
          return if @state.winner || @state.tie

          check_win
          check_tie

          @animation_queue.unshift(
            PieceAnimation.animate(self, @state.board.last_move) do
              render_board
              @game_engine.play
            end
          )
        end

        def each(&block)
          @board_objects.each(&block)
        end

        def find_index(&block)
          @board_objects.find_index(&block)
        end

        def clear
          @board_objects.each(&:remove) if @board_objects&.any?
        end

        def square_at(row, col)
          return @board_objects[row, col] if @board_objects[row, col].is_a?(Square)
        end

        def piece_at(row, col)
          return @board_objects[row, col] if @board_objects[row, col].is_a?(Ruby2D::SquareWithPiece)
        end

        private

        def check_win
          human_pieces = @state.board.count_pieces(player: :human)
          ai_pieces = @state.board.count_pieces(player: :ai)

          @state.set_state(winner: :human) if ai_pieces.zero?
          @state.set_state(winner: :ai) if human_pieces.zero?
        end

        def check_tie
          @state.set_state(tie: true) if tie?
        end

        def tie?
          return false unless @state.winner.nil?

          if @state.board.find_moves_for_player(player: @state.turn).length.zero?
            turn = @state.turn == :human ? :ai : :human

            return true if @state.board.find_moves_for_player(player: turn).length.zero?
          end

          false
        end

        def render_board
          clear
          @board_objects = Matrix.zero(8)

          x = y = 0
          square_color = 'white'

          @state.board.each_with_index do |piece, row, col|
            x = col * SQUARE_SIZE
            y = row * SQUARE_SIZE
            @board_objects[row, col] = if piece.zero?
                                         Square.new(x: x, y: y, size: SQUARE_SIZE, color: square_color)
                                       else
                                         Ruby2D::SquareWithPiece.new(
                                           x: x,
                                           y: y,
                                           size: SQUARE_SIZE,
                                           color: square_color,
                                           piece: piece
                                         )
                                       end

            square_color = square_color == 'white' ? 'black' : 'white'
            square_color = square_color == 'white' ? 'black' : 'white' if col == @state.board.row_count - 1
          end
        end
      end
    end
  end
end
