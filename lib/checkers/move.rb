# frozen_string_literal: true

module Checkers
  class Move
    attr_reader :start_square, :end_square

    def initialize(start_square, end_square)
      @start_square = start_square
      @end_square = end_square
    end

    def ==(other)
      start_square == other.start_square && end_square == other.end_square
    end
  end
end
