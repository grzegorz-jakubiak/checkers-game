#  frozen_string_literal: true

module Checkers
  class Board
    module Score
      def number_of_pieces(player:)
        opponent = opponent(player)
        player_pieces = board.count { |piece| piece == player }
        opponent_pieces = board.count { |piece| piece == opponent }
        opponent_pieces - player_pieces
      end

      def number_of_pieces_on_opponets_side(player:)
        opponent = opponent(player)

        player_pieces = board.each_with_index.count do |piece, row, _col|
          next if row >= 3

          piece == player
        end

        opponent_pieces = board.each_with_index.count do |piece, row, _col|
          next unless row == 5

          piece == opponent
        end

        opponent_pieces - player_pieces
      end

      # for kings implementation
      def number_of_unoccupied_promotion_squares(player:)
        opponent = opponent(player)
        opponent_squares = 0
        player_squares = 0

        board.each_with_index do |square, row, _col|
          next if square == player || square == opponent

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
          next if piece == :empty

          if piece == player
            player_pieces += 1 if movable_squares(row: row, col: col, player: player).any?
          else
            opponent_pieces += 1 if movable_squares(row: row, col: col, player: opponent).any?
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
