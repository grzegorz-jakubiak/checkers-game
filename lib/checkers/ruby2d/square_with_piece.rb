# frozen_string_literal: true

module Checkers
  module Ruby2D
    class SquareWithPiece < Square
      extend Forwardable

      def_delegators :@piece, :player

      def initialize(opts = {})
        @piece = Piece.new(
          x: opts[:x] + Checkers::GUI::CIRCLE_TRANSLATION,
          y: opts[:y] + Checkers::GUI::CIRCLE_TRANSLATION,
          z: 1,
          radius: Checkers::GUI::RADIUS,
          color: opts[:piece_color],
          player: opts[:player]
        )
        super(opts.slice(:x, :y, :size, :color))
      end

      def remove
        @piece.remove
        super
      end
    end
  end
end
