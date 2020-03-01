# frozen_string_literal: true

RSpec.describe ResourceIdentifierContract do
  describe '#call' do
    subject(:errors) { described_class.new.call(params).errors.to_h }

    context 'without id param' do
      let(:params) { {} }

      it 'returns "is required" error' do
        expect(errors).to eq({ id: ['is required'] })
      end
    end

    context 'with id param' do
      let(:params) { { id: id } }

      context 'when starts with 0' do
        let(:id) { '0123' }

        it 'returns "invalid format" error' do
          expect(errors).to eq({ id: ['is in invalid format'] })
        end
      end

      context 'when negative' do
        let(:id) { '-123' }

        it 'returns "invalid format" error' do
          expect(errors).to eq({ id: ['is in invalid format'] })
        end
      end

      context 'when too long' do
        let(:id) { '92233720368547758079' }

        it 'returns "invalid format" error' do
          expect(errors).to eq({ id: ['is in invalid format'] })
        end
      end

      context 'when valid' do
        let(:id) { '9223372036854775807' }

        it 'returns empty hash' do
          expect(errors).to eq({})
        end
      end
    end
  end
end
