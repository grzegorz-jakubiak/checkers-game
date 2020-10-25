#  frozen_string_literal: true

module Checkers
  class Board
    module Score
      def number_of_pieces(player:)
        opponent = opponent(player)
        player_pieces = board.count { |piece| player_pieces(player).include?(piece) }
        opponent_pieces = board.count { |piece| player_pieces(opponent).include?(piece) }
        opponent_pieces - player_pieces
      end

      def number_of_pieces_on_opponets_side(player:)
        opponent = opponent(player)

        player_pieces = board.each_with_index.count do |piece, row, _col|
          next if row >= 3

          player_pieces(player).include?(piece)
        end

        opponent_pieces = board.each_with_index.count do |piece, row, _col|
          next unless row == 5

          player_pieces(opponent).include?(piece)
        end

        opponent_pieces - player_pieces
      end

      # for kings implementation
      def number_of_unoccupied_promotion_squares(player:)
        opponent = opponent(player)
        opponent_squares = 0
        player_squares = 0

        board.each_with_index do |square, row, _col|
          next if player_pieces(player).include?(square) || player_pieces(opponent).include?(square)

          opponent_squares += 1 if row == 7
          player_squares += 1 if row.zero?
        end

        opponent_squares - player_squares
      end

      def movable_pieces(player:)
        opponent = opponent(player)
        opponent_pieces = 0
        player_pieces = 0

        board.each_with_index do |piece, row, col|
          next if piece.zero?

          if player_pieces(player).include?(piece) && movable_squares(row: row, col: col, player: player).any?
            player_pieces += 1
          elsif movable_squares(row: row, col: col, player: opponent).any?
            opponent_pieces += 1
          end
        end

        opponent_pieces - player_pieces
      end

      private

      def opponent(player)
        player == :human ? :ai : :human
      end
    end
  end
end
