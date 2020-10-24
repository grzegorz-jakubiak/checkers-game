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

        def square_at(row, col)
          @board_objects[row, col].find { |object| object.is_a?(Square) }
        end

        private

        def render_board
          @board_objects = Matrix.zero(8)

          x = y = 0
          square_color = 'white'

          @state.board.each_with_index do |square, row, col|
            x = col * SQUARE_SIZE
            y = row * SQUARE_SIZE
            @board_objects[row, col] = [Square.new(x: x, y: y, size: SQUARE_SIZE, color: square_color)]
            unless square == :empty
              @board_objects[row, col] << Ruby2D::Piece.new(
                x: x + CIRCLE_TRANSLATION,
                y: y + CIRCLE_TRANSLATION,
                radius: RADIUS,
                color: square == :human ? 'red' : 'yellow',
                player: square
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
