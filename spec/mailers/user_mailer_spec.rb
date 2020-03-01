# frozen_string_literal: true

RSpec.describe UserMailer, type: :mailer do
  let(:user) { instance_double(User) }

  before do
    allow(user).to receive(:email).and_return('me@example.com')
    allow(user).to receive(:name).and_return('Adam')
    allow(user).to receive(:created_at).and_return(Time.zone.now)
  end

  describe '#registration' do
    subject(:mailer) { described_class.registration(user) }

    it 'has correct subject' do
      expect(mailer.subject).to eq('Welcome Adam!')
    end

    it 'has correct recipient' do
      expect(mailer.to).to eq(['me@example.com'])
    end

    it 'has correct sender' do
      expect(mailer.from).to eq(['hi@daftcode.pl'])
    end
  end

  describe 'deletion' do
    subject(:mailer) { described_class.deletion(user) }

    it 'has correct subject' do
      expect(mailer.subject).to eq('Sorry to see you go Adam!')
    end

    it 'has correct recipient' do
      expect(mailer.to).to eq(['me@example.com'])
    end

    it 'has correct sender' do
      expect(mailer.from).to eq(['hi@daftcode.pl'])
    end
  end
end
