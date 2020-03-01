# frozen_string_literal: true

RSpec.describe ErrorsSerializer do
  describe '#initialize' do
    subject(:init) { described_class.new(errors) }

    before { init }

    context 'with string' do
      let(:errors) { 'something went wrong' }

      it 'sets @errors to an array of a single string given' do
        expect(init.instance_variable_get(:@errors).class).to be(Array)
        expect(init.instance_variable_get(:@errors).size).to be(1)
      end
    end

    context 'with hash' do
      let(:errors) { { id: ['is invalid', 'is too short'], name: ['is too long'] } }

      it 'sets @errors to an array of mapped hash values' do
        expect(init.instance_variable_get(:@errors).class).to be(Array)
        expect(init.instance_variable_get(:@errors).size).to be(2)
        expect(init.instance_variable_get(:@errors).first).to eq('id is invalid, is too short')
        expect(init.instance_variable_get(:@errors).second).to eq('name is too long')
      end
    end
  end

  describe '#serialize' do
    subject(:serialized) { described_class.new('nope').serialize }

    it 'returns correct format' do
      expect(serialized).to eq({ errors: [{ title: 'nope' }] })
    end
  end
end
