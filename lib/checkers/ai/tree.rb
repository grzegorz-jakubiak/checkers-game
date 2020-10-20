# frozen_string_literal: true

module Checkers
  module AI
    class Tree
      attr_reader :root

      def self.build(board, depth)
        Tree.new(Node.new(board, :ai, depth))
      end

      def initialize(node)
        @root = node
      end

      def depth
        current_depth = 0
        children = @root.children

        while children.any?
          current_depth += 1
          children = children.first.children
        end

        current_depth
      end
    end
  end
end
