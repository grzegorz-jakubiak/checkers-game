# frozen_string_literal: true

module Checkers
  module AI
    module Decision
      def alphabeta(node, tree_depth, a, b, maxplayer)
        return node.score if tree_depth.zero? || node.children_size.zero?

        if maxplayer
          node.children.each do |child|
            a = max(a, alphabeta(child, depth - 1, a, b, !maxplayer))
            break if a >= b
          end

          node.score = a
        else
          node.children.each do |child|
            b = min(b, alphabeta(child, depth - 1, a, b, !maxplayer))
            break if a >= b
          end

          node.score = b
        end
      end

      def minmax(node, tree_depth, maxplayer)
        return node.score if tree_depth.zero? || node.children_size.zero?

        value = nil

        if maxplayer
          value = Float::MIN

          node.children.each do |child|
            value = max(value, minmax(child, depth - 1, !maxplayer))
          end
        else
          value = Float::MAX

          node.children.each do |child|
            value = min(value, minmax(child, depth - 1, !maxplayer))
          end
        end

        node.score = value
      end
    end

    private

    def max(a, b)
      a > b ? a : b
    end

    def min(a, b)
      a < b ? a : b
    end
  end
end
