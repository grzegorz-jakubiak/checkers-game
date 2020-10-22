# frozen_string_literal: true

module Checkers
  module Game
    class State
      include Observable

      attr_accessor :winner, :tie, :board, :turn
      private :winner=, :tie=, :board=, :turn=

      def initialize(turn)
        @board = Board.new
        @turn = turn
        @winner = nil
        @tie = false
      end

      def set_state(attrs = {})
        changed
        attrs.each { |attr, value| send("#{attr}=", value) }
        notify_observers
      end
    end
  end
end
