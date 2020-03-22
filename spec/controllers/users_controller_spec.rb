# frozen_string_literal: true

RSpec.describe UsersController do
  let(:user) { instance_double(User) }
  let(:parsed_response_body) { JSON.parse(response.body, symbolize_names: true) }
  let(:contract) { instance_double(UserContract) }

  before do
    request.headers['Content-Type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
  end

  describe 'POST create' do
    let(:params) { { email: 'me@example.com', name: 'Adam', birth_date: '2000-01-01' } }

    before { allow(User).to receive(:new).and_return(user) }

    context 'with invalid payload' do
      include_context('contract_call')
      let(:contract_errors) { { id: ['bad'] } }

      before do
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        post :create, params: params
      end

      it 'responds with unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation error' do
        expect(parsed_response_body[:errors]).to eq([{ title: 'id bad' }])
      end
    end

    context 'with already existing email' do
      include_context('contract_call')
      let(:contract_errors) { {} }

      before do
        allow(user).to receive(:save!).and_raise(ActiveRecord::RecordNotUnique)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        post :create, params: params
      end

      it 'responds with conflict' do
        expect(response).to have_http_status(:conflict)
      end

      it 'returns validation error' do
        expect(parsed_response_body[:errors]).to eq([{ title: 'Email already in use' }])
      end
    end

    context 'when the user fails to save' do
      include_context('contract_call')
      let(:contract_errors) { {} }

      before do
        allow(user).to receive(:save!).and_return(false)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        post :create, params: params
      end

      it 'responds with bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns validation error' do
        expect(parsed_response_body[:errors]).to eq([{ title: 'Invalid request' }])
      end
    end

    context 'when the user saves succesfully' do
      let(:delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:mailer) { class_double(UserMailer).as_stubbed_const(transfer_nested_constants: true) }
      let(:contract_errors) { {} }

      include_context('contract_call')

      before do
        allow(user).to receive(:attributes).and_return(params)
        allow(mailer).to receive(:registration).and_return(delivery)
        allow(delivery).to receive(:deliver_now!)
        allow(user).to receive(:save!).and_return(true)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        post :create, params: params
      end

      it 'creates user' do
        expect(user).to have_received(:save!).once
      end

      it 'responds with created' do
        expect(response).to have_http_status(:created)
      end

      it 'does not return validation error' do
        expect(parsed_response_body[:errors]).to be_nil
      end

      it 'returns created resource' do
        expect(parsed_response_body).to eq(params)
      end

      it 'sends registration email' do
        expect(UserMailer).to have_received(:registration).once
        expect(delivery).to have_received(:deliver_now!).once
      end
    end
  end

  describe 'PATCH update' do
    let(:params) { { id: '1', email: 'me@example.com', name: 'Adam', birth_date: '2000-01-01' } }

    context 'when user does not exist' do
      before do
        allow(User).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound)
        patch :update, params: params
      end

      it 'responds with not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with invalid payload' do
      include_context('contract_call')
      let(:contract_errors) { { id: ['nope'] } }

      before do
        allow(User).to receive(:find_by!).and_return(user)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        patch :update, params: params
      end

      it 'responds with unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation error' do
        expect(parsed_response_body[:errors]).to eq([{ title: 'id nope' }])
      end
    end

    context 'with already existing email' do
      include_context('contract_call')
      let(:contract_errors) { {} }

      before do
        allow(User).to receive(:find_by!).and_return(user)
        allow(user).to receive(:update!).and_raise(ActiveRecord::RecordNotUnique)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        patch :update, params: params
      end

      it 'responds with conflict' do
        expect(response).to have_http_status(:conflict)
      end

      it 'returns validation error' do
        expect(parsed_response_body[:errors]).to eq([{ title: 'Email already in use' }])
      end
    end

    context 'when the user fails to update' do
      include_context('contract_call')
      let(:contract_errors) { {} }

      before do
        allow(User).to receive(:find_by!).and_return(user)
        allow(user).to receive(:update!).and_return(false)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        patch :update, params: params
      end

      it 'responds with bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns validation error' do
        expect(parsed_response_body[:errors]).to eq([{ title: 'Invalid request' }])
      end
    end

    context 'when the user updates succesfully' do
      let(:contract_errors) { {} }

      include_context('contract_call')

      before do
        allow(User).to receive(:find_by!).and_return(user)
        allow(user).to receive(:update!).and_return(true)
        allow(UserContract).to receive(:new).and_return(contract)
        allow(contract).to receive(:call).and_return(contract_call)
        patch :update, params: params
      end

      it 'updates user' do
        expect(user).to have_received(:update!).once
      end

      it 'responds with no content' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:params) { { id: '1' } }

    context 'when user does not exist' do
      before do
        allow(User).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, params: params
      end

      it 'responds with not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user exists' do
      let(:delivery) { instance_double(ActionMailer::MessageDelivery) }
      let(:mailer) { class_double(UserMailer).as_stubbed_const(transfer_nested_constants: true) }
      let(:user_attributes) { { email: 'me@example.com', name: 'Adam', birth_date: '2000-01-01' } }

      before do
        allow(User).to receive(:find_by!).and_return(user)
        allow(user).to receive(:delete).and_return(user)
        allow(user).to receive(:attributes).and_return(user_attributes)
        allow(mailer).to receive(:deletion).and_return(delivery)
        allow(delivery).to receive(:deliver_now!)
        delete :destroy, params: params
      end

      it 'deletes user' do
        expect(user).to have_received(:delete).once
      end

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns deleted user data' do
        expect(parsed_response_body).to eq(user_attributes)
      end

      it 'sends deletion email' do
        expect(mailer).to have_received(:deletion).once
        expect(delivery).to have_received(:deliver_now!).once
      end
    end
  end
end
