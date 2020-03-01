# frozen_string_literal: true

RSpec.describe UserContract do
  describe '#call' do
    subject(:error) { described_class.new(action).call(params).errors.to_h[field] }

    before { Timecop.freeze('2020-03-01') }

    after { Timecop.return }

    let(:params) { { email: 'me@example.com', birth_date: '2000-03-02'.to_date, name: 'Adam' } }
    let(:action) { 'update' }

    describe 'create action required fields' do
      let(:action) { 'create' }

      context 'when email is missing' do
        let(:field) { :email }

        before { params[:email] = nil }

        it 'returns "is required" error' do
          expect(error).to eq(['is required'])
        end
      end

      context 'when name is missing' do
        let(:field) { :name }

        before { params[:name] = nil }

        it 'returns "is required" error' do
          expect(error).to eq(['is required'])
        end
      end

      context 'when birth_date is missing' do
        let(:field) { :birth_date }

        before { params[:birth_date] = nil }

        it 'returns "is required" error' do
          expect(error).to eq(['is required'])
        end
      end
    end

    describe 'name' do
      let(:field) { :name }

      context 'when too short' do
        before { params[:name] = 'A' }

        it 'returns "is too short" error' do
          expect(error).to eq(['is too short'])
        end
      end

      context 'when too long' do
        before { params[:name] = 'A' * 256 }

        it 'returns "is too long" error' do
          expect(error).to eq(['is too long'])
        end
      end

      context 'with invalid characters' do
        it_behaves_like('no unsafe characters')
      end

      context 'when valid' do
        it { is_expected.to be_nil }
      end
    end

    describe 'birth_date' do
      let(:field) { :birth_date }

      context 'when mixed format' do
        before { params[:birth_date] = '2000-03/01' }

        it 'returns "invalid format" error' do
          expect(error).to eq(['is in invalid format'])
        end
      end

      context 'when not a valid date' do
        before { params[:birth_date] = '2000-02-30' }

        it 'returns "not a date" error' do
          expect(error).to eq(['is not a valid date'])
        end
      end

      context 'when too early' do
        before { params[:birth_date] = '2020-03-02' }

        it 'returns "too early" error' do
          expect(error).to eq(['cannot be later than 2020-03-01'])
        end
      end

      context 'when too late' do
        before { params[:birth_date] = '1900-02-28' }

        it 'returns "too late" error' do
          expect(error).to eq(['cannot be earlier than 1900-03-01'])
        end
      end

      describe 'email' do
        let(:field) { :email }

        context 'without "@" character' do
          before { params[:email] = 'meexample.com' }

          it { is_expected.to eq(['is missing @ character']) }
        end

        context 'with invalid character in the local part' do
          before { params[:email] = 'mó@example.com' }

          it { is_expected.to eq(['local has invalid characters']) }
        end

        context 'with subsequent dots in the domain' do
          before { params[:email] = 'me@exa..mple.com' }

          it { is_expected.to eq(['domain has subsequent dot characters']) }
        end

        context 'with leading dot in the domain' do
          before { params[:email] = 'me@.example.com' }

          it { is_expected.to eq(['domain has leading dot character']) }
        end

        context 'with trailing dot in the domain' do
          before { params[:email] = 'me@example.com.' }

          it { is_expected.to eq(['domain has trailing dot character']) }
        end

        context 'with leading whitespace in the domain' do
          before { params[:email] = "me@\texample.com" }

          it { is_expected.to eq(['domain has leading whitespace character']) }
        end

        context 'with trailing whitespace in the domain' do
          before { params[:email] = "me@example.com\n" }

          it { is_expected.to eq(['domain has trailing whitespace character']) }
        end

        context 'when dot character is missing in the domain' do
          before { params[:email] = 'me@examplecom' }

          it { is_expected.to eq(['domain does not have dot character']) }
        end

        context 'when subdomain has invalid character' do
          before { params[:email] = 'me@example.$e' }

          it { is_expected.to eq(['subdomain $e has invalid chars']) }
        end

        context 'when subdomain has leading hyphen' do
          before { params[:email] = 'me@example.-com' }

          it { is_expected.to eq(['subdomain -com has leading hyphen']) }
        end

        context 'when subdomain has trailing hyphen' do
          before { params[:email] = 'me@example.com-' }

          it { is_expected.to eq(['subdomain com- has trailing hyphen']) }
        end
      end
    end
  end
end
