# frozen_string_literal: true

module Checkers
  module GUI
    class Scene
      class PieceAnimation
        attr_writer :animation_proc
        attr_accessor :finished

        def initialize
          @finished = false
        end

        def call
          @animation_proc.call
        end

        class << self
          def animate(board, move)
            object = board.piece_at(*move.start_square)&.piece
            square = board.square_at(*move.end_square)
            x = square.x + Checkers::GUI::CIRCLE_TRANSLATION - object.x
            y = square.y + Checkers::GUI::CIRCLE_TRANSLATION - object.y
            object.z = 10

            animation = PieceAnimation.new

            animation.animation_proc = proc do
              unless x.zero?
                if x.negative?
                  x += 1
                  object.x -= 1
                else
                  x -= 1
                  object.x += 1
                end
              end

              unless y.zero?
                if y.negative?
                  y += 1
                  object.y -= 1
                else
                  y -= 1
                  object.y += 1
                end
              end

              if x.zero? && y.zero?
                yield if block_given?
                animation.finished = true
              end
            end

            animation
          end
        end
      end
    end
  end
end
