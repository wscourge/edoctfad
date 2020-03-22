# frozen_string_literal: true

RSpec.shared_context 'contract_call' do
  let(:contract_call) { instance_double(Dry::Validation::Result) }

  before do
    allow(contract_call).to receive(:errors).and_return(contract_errors)
  end
end
