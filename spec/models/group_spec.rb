require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'when name is nil' do
    subject { build(:group, name: nil) }
    it { is_expected.not_to be_valid }
  end

  context 'when name is an empty string' do
    subject { build(:group, name: '') }
    it { is_expected.not_to be_valid }
  end
end
