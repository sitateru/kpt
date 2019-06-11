require 'rails_helper'

RSpec.describe IssueTag, type: :model do
  let(:issue) { create(:issue) }
  let(:tag) { create(:tag) }

  context 'when issue id and tag id are valid' do
    subject { build(:issue_tag, tag_id: tag.id, issue_id: issue.id) }
    it { is_expected.to be_valid }
  end

  context 'when the pair of ids is not unique' do
    before do
      create(:issue_tag, tag_id: tag.id, issue_id: issue.id)
    end

    context 'create model instance' do
      subject { build(:issue_tag, tag_id: tag.id, issue_id: issue.id) }
      it { is_expected.to_not be_valid }
    end

    context 'create model instance and save' do
      let(:issue_tag) do
        build(:issue_tag, tag_id: tag.id, issue_id: issue.id)
      end

      it { expect { issue_tag.save!(validate: false) }.to raise_error ActiveRecord::RecordNotUnique }
    end
  end

  context 'when there is no record with specified id' do
    context 'does not exists in the tags table' do
      subject { build(:issue_tag, tag_id: tag.id + 1, issue_id: issue.id) }
      it { is_expected.to_not be_valid }
    end

    context 'does not exists in the issues table' do
      subject { build(:issue_tag, tag_id: tag.id, issue_id: issue.id + 1) }
      it { is_expected.to_not be_valid }
    end
  end
end
