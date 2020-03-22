# frozen_string_literal: true

RSpec.shared_examples 'application_controller' do
  context 'without Accept: application/json header' do
    before { request.headers['Accept'] = 'application/xml' }

    it 'responds with not acceptable' do
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns validation error' do
      expect(parsed_response_body[:errors])
        .to eq([{ title: 'Header Accept application/json is required' }])
    end
  end

  context 'without Content-Type: application/json header' do
    before { request.headers['Content-Type'] = 'application/xml' }

    it 'responds with not acceptable' do
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns validation error' do
      expect(parsed_response_body[:errors])
        .to eq([{ title: 'Header Content-Type application/json is required' }])
    end
  end
end
