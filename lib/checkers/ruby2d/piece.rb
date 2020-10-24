# frozen_string_literal: true

module Checkers
  module Ruby2D
    class Piece < Circle
      attr_accessor :player

      def initialize(opts = {})
        @player = opts[:player] || nil
        super
      end
    end
  end
end
