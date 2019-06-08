require 'rails_helper'

RSpec.describe Tag, type: :model do
  context 'when name is nil' do
    subject { build(:tag, name: nil) }
    it { is_expected.not_to be_valid }
  end

  context 'when name is an empty string' do
    subject { build(:tag, name: '') }
    it { is_expected.not_to be_valid }
  end
end
