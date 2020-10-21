# frozen_string_literal: true

RSpec.describe Checkers::Board do
  describe '#find_moves_for_player' do
    subject(:result) { board.find_moves_for_player(player: player) }
    let(:board) { described_class.new }

    shared_examples 'returns expected moves' do
      it 'contains expected moves' do
        expect(result).to match_array(expected_moves)
      end
    end

    context 'when player human' do
      let(:player) { :human }
      let(:expected_moves) do
        {
          [5, 0] => [[4, 1]],
          [5, 2] => [[4, 1], [4, 3]],
          [5, 4] => [[4, 3], [4, 5]],
          [5, 6] => [[4, 5], [4, 7]]
        }.inject([]) do |acc, key_value|
          key, value = key_value
          acc += value.map {Checkers::Move.new(key, _1)}
          acc
        end
      end

      it_behaves_like 'returns expected moves'
    end

    context 'when player ai' do
      let(:player) { :ai }
      let(:expected_moves) do
        {
          [2, 1] => [[3, 0], [3, 2]],
          [2, 3] => [[3, 2], [3, 4]],
          [2, 5] => [[3, 4], [3, 6]],
          [2, 7] => [[3, 6]]
        }.inject([]) do |acc, key_value|
          key, value = key_value
          acc += value.map {Checkers::Move.new(key, _1)}
          acc
        end
      end

      it_behaves_like 'returns expected moves'
    end
  end
end
