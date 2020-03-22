# frozen_string_literal: true

RSpec.describe User do
  describe '#birthday?' do
    subject { create(:user, birth_date: birth_date).birthday? }

    after { Timecop.return }

    context 'when birth date is today' do
      let(:birth_date) { 30.years.ago }

      before { Timecop.freeze(birth_date) }

      it { is_expected.to be(true) }
    end

    context 'when birth date is not today' do
      let(:birth_date) { 30.years.ago }

      before { Timecop.freeze(125.days.ago.to_date) }

      it { is_expected.to be(false) }
    end
  end
end
