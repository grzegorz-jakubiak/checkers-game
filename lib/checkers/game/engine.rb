# frozen_string_literal: true

module Checkers
  module Game
    class Engine
      def initialize(state, ai_engine)
        @state = state
        @ai = ai_engine
      end

      def play
        return if @state.winner || @state.tie

        if @state.turn == :ai
          new_board = @ai.next_board(@state.board)

          turn = if new_board.jumped
                   new_board.any_jump_moves?(player: :ai) ? :ai : :human
                 else
                   :human
                 end

          @state.set_state(board: new_board, turn: turn)
        end
      end
    end
  end
end
