# frozen_string_literal: true

module Checkers
  module AI
    module Engine
      class Alphabeta < Base
        def next_board(board)
          super(board) { |root, tree_depth| alphabeta(root, tree_depth, Float::MIN, Float::MAX, true) }
        end

        private

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
      end
    end
  end
end
