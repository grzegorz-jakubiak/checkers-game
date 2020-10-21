# frozen_string_literal: true

RSpec.describe Checkers::JumpMove do
  describe '#jump_over_square' do
    subject { move.jump_over_square }

    let(:move) { described_class.new(start_square, end_square) }
    let(:start_square) { [3, 2] }
    let(:end_square) { [5, 0] }
    let(:expected_value) { [4, 1] }

    it 'returns jump over square' do
      expect(subject).to eq(expected_value)
    end
  end
end
