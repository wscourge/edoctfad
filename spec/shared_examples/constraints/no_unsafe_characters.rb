# frozen_string_literal: true

RSpec.shared_examples 'no unsafe characters' do
  context 'with "!" character' do
    before { params[:name] = "#{params[:name]}!" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "@" character' do
    before { params[:name] = "#{params[:name]}@" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "#" character' do
    before { params[:name] = "#{params[:name]}#" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "$" character' do
    before { params[:name] = "#{params[:name]}$" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "%" character' do
    before { params[:name] = "#{params[:name]}%" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "^" character' do
    before { params[:name] = "#{params[:name]}^" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "&" character' do
    before { params[:name] = "#{params[:name]}&" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "*" character' do
    before { params[:name] = "#{params[:name]}*" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "_" character' do
    before { params[:name] = "#{params[:name]}_" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "=" character' do
    before { params[:name] = "#{params[:name]}=" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "+" character' do
    before { params[:name] = "#{params[:name]}+" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "<" character' do
    before { params[:name] = "#{params[:name]}<" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with ">" character' do
    before { params[:name] = "#{params[:name]}>" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "/" character' do
    before { params[:name] = "#{params[:name]}/" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "{" character' do
    before { params[:name] = "#{params[:name]}{" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "}" character' do
    before { params[:name] = "#{params[:name]}}" }

    it { is_expected.to eq(['is in invalid format']) }
  end

  context 'with "~" character' do
    before { params[:name] = "#{params[:name]}~" }

    it { is_expected.to eq(['is in invalid format']) }
  end
end
