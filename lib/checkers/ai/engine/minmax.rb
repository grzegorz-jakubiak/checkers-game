# frozen_string_literal: true

module Checkers
  module AI
    module Engine
      class Minmax < Base
        def next_board(board)
          super(board) { |root, tree_depth| minmax(root, tree_depth, true) }
        end

        private 

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
      end
    end
  end
end
