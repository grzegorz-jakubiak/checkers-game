# frozen_string_literal: true

module Checkers
  module Game
    class Engine
      attr_reader :state

      private_class_method :new

      def self.start_game(starting_player)
        Engine.new(starting_player)
      end

      def initialize(starting_player)
        @state = State.new(starting_player)
      end

      def check_win
        human_pieces = state.board.count_pieces(player: :human)
        ai_pieces = state.board.count_pieces(player: :ai)

        state.set_state(winner: :human) if ai_pieces.zero?
        state.set_state(winner: :ai) if human_pieces.zero?
      end

      def check_tie
        state.set_state(tie: true) if tie?
      end

      def tie?
        return false unless winner.nil?

        if state.board.find_moves_for_player(state.turn).length.zero?
          turn = state.turn == :human ? :ai : :human

          return true if state.board.find_moves_for_player(turn).length.zero?
        end

        false
      end
    end
  end
end
