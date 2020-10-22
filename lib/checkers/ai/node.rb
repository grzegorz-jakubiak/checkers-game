# frozen_string_literal: true

module Checkers
  module AI
    class Node
      attr_reader :children, :player, :board, :score

      def initialize(board, player, depth = 0)
        @board = board
        @player = player
        @children = generate_children(depth)
      end

      def children_size
        @children.size
      end

      private

      def generate_children(depth)
        return [] if depth.zero?

        plays_next = player == :human ? :ai : :human
        boards = Board.generate_boards(board, player)
        boards.map { |board| Node.new(board, plays_next, depth - 1) }
      end
    end
  end
end
