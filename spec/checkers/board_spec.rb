# frozen_string_literal: true

RSpec.describe Checkers::Board do
  describe '#number_of_pieces' do
    subject(:result) { board.number_of_pieces(player: player) }
    let(:player) { :human }

    context 'when game started' do
      let(:board) { described_class.new }

      it 'returns 0' do
        expect(result).to eq(0)
      end
    end

    context 'when ai jumped over human' do
      let(:board) do
        described_class.new(board: Matrix[
          [0, 1, 0, 1, 0, 1, 0, 1],
          [1, 0, 1, 0, 1, 0, 1, 0],
          [0, 1, 0, 0, 0, 1, 0, 1],
          [0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0],
          [1, 0, -1, 0, -1, 0, -1, 0],
          [0, -1, 0, -1, 0, -1, 0, -1],
          [-1, 0, -1, 0, -1, 0, -1, 0]
        ])
      end

      it 'returns 1' do
        expect(result).to eq(1)
      end
    end
  end

  describe '#number_of_pieces_on_opponets_side' do
    subject(:result) { board.number_of_pieces_on_opponets_side(player: player) }
    let(:player) { :human }

    context 'when ai jumped over human' do
      let(:board) do
        described_class.new(board: Matrix[
          [0, 1, 0, 1, 0, 1, 0, 1],
          [1, 0, 1, 0, 1, 0, 1, 0],
          [0, 1, 0, 0, 0, 1, 0, 1],
          [0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0],
          [1, 0, -1, 0, -1, 0, -1, 0],
          [0, -1, 0, -1, 0, -1, 0, -1],
          [-1, 0, -1, 0, -1, 0, -1, 0]
        ])
      end

      it 'returns 1' do
        expect(result).to eq(1)
      end
    end
  end

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

    context 'when jump' do
      let(:board) do
        described_class.new(board: Matrix[
          [0, 1, 0, 1, 0, 1, 0, 1],
          [1, 0, 1, 0, 1, 0, 1, 0],
          [0, 1, 0, 0, 0, 1, 0, 1],
          [0, 0, 1, 0, 0, 0, 0, 0],
          [0, -1, 0, 0, 0, 0, 0, 0],
          [0, 0, -1, 0, -1, 0, -1, 0],
          [0, -1, 0, -1, 0, -1, 0, -1],
          [-1, 0, -1, 0, -1, 0, -1, 0]
        ])
      end
      let(:player) { :ai }
      let(:expected_moves) do
        [Checkers::JumpMove.new([3, 2], [5, 0])]
      end

      it_behaves_like 'returns expected moves'
    end
  end
end
