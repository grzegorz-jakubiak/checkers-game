# frozen_string_literal: true

module Checkers
  module Ruby2D
    class Piece < Circle
      HUMAN_PIECE_COLOR = 'red'
      HUMAN_KING_COLOR = 'maroon'
      AI_PIECE_COLOR = 'yellow'
      AI_KING_COLOR = 'orange'

      attr_accessor :player

      def initialize(opts = {})
        @player = HUMAN_PIECES.include?(opts[:piece]) ? :human : :ai
        super(opts.merge({ color: piece_color(opts[:piece]) }))
      end

      private

      def piece_color(piece)
        if HUMAN_PIECES.include?(piece)
          piece == HUMAN_PIECE ? HUMAN_PIECE_COLOR : HUMAN_KING_COLOR
        else
          piece == AI_PIECE ? AI_PIECE_COLOR : AI_KING_COLOR
        end
      end
    end
  end
end
