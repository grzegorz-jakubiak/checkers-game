# frozen_string_literal: true

module Checkers
  class JumpMove < Move
    attr_reader :jump_over_square

    def initialize(start_square, end_square)
      super
      @jump_over_square = calculate_jump_over_square
    end

    private

    def calculate_jump_over_square
      [(end_square[0] + start_square[0]) / 2, (end_square[1] + start_square[1]) / 2]
    end
  end
end
