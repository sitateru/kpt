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

  context 'relation tag and issue' do
    let(:tag) { create(:tag) }
    let(:issue) { create(:issue) }

    subject { tag.tap { |tag| tag.issue_ids = [issue.id] }.issue_ids }
    it { is_expected.to match_array([issue.id]) }
  end
end
