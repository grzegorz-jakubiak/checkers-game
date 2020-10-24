# frozen_string_literal: true

module Checkers
  module GUI
    class Scene
      include Enumerable

      SQUARE_SIZE = 50
      CIRCLE_TRANSLATION = SQUARE_SIZE * Integer.sqrt(2) / 2
      RADIUS = 20

      def initialize(state)
        @objects = []
        @state = state
        @state.add_observer(self)
        render_board
      end

      def update
        @objects = [] if @objects.any?

        render_board
      end

      def each(&block)
        @board_objects.each(&block)
      end

      def find_index(&block)
        @board_objects.find_index(&block)
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
            @board_objects[row, col] << Circle.new(
              x: x + CIRCLE_TRANSLATION,
              y: y + CIRCLE_TRANSLATION,
              radius: RADIUS,
              color: square == :human ? 'red' : 'yellow'
            )
          end
          square_color = square_color == 'white' ? 'black' : 'white'
          square_color = square_color == 'white' ? 'black' : 'white' if col == @state.board.row_count - 1
        end
      end
    end
  end
end
