# frozen_string_literal: true

module Checkers
  module GUI
    class Scene
      class Board
        include Enumerable

        def initialize(state)
          @state = state
          @state.add_observer(self)
          render_board
        end

        def update
          render_board
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

        private

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
