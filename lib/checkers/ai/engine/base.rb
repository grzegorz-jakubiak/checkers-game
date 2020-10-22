# frozen_string_literal: true

module Checkers
  module AI
    module Engine
      class Base
        attr_reader :tree_depth

        def initialize(tree_depth = 3)
          @tree_depth = tree_depth
        end

        def next_board(board)
          if board.jumped
            Board.generate_boards(board, :ai).first
          else
            decision_tree_root = Tree.build(board, tree_depth).root

            yield(decision_tree_root, tree_depth)

            decision_tree_root.children.max_by(&:score).board
          end
        end

        protected

        def max(a, b)
          a > b ? a : b
        end

        def min(a, b)
          a < b ? a : b
        end
      end
    end
  end
end
