require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe 'title validate' do
    subject { build(:issue, title: '') }
    it { expect(subject).not_to be_valid }
  end

  context 'relation issue and tag' do
    let(:issue) { create(:issue) }
    let(:tag) { create(:tag) }

    subject { issue.tap { |issue| issue.tag_ids = [tag.id] }.tag_ids }
    it { is_expected.to match_array([tag.id]) }
  end
end
