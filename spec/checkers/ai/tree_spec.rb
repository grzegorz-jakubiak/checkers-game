# frozen_string_literal: true

RSpec.describe Checkers::AI::Tree do
  describe '#depth' do
    subject { tree.depth }

    let(:tree) { described_class.build(board, depth) }
    let(:board) { Checkers::Board.new }
    let(:depth) { 3 }

    it 'returns tree depth' do
      expect(subject).to eq(depth)
    end
  end
end
