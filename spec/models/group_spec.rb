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

  context 'relation group and user' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    subject { group.tap { |group| group.user_ids = [user.id] }.user_ids }
    it { is_expected.to match_array([user.id]) }
  end
end
