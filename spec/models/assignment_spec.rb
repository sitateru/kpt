require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe "validation ok" do
    let!(:issue) { create(:issue) }
    let!(:user) { create(:user) }
    it { expect(build(:assignment, user_id: user.id, issue_id: issue.id)).to be_valid }
  end
  describe "validation ng" do
    context "when not unique" do
      let!(:issue) { create(:issue) }
      let!(:user) { create(:user) }
      it do
        create(:assignment, user_id: user.id, issue_id: issue.id)
        expect(build(:assignment, user_id: user.id, issue_id: issue.id)).to_not be_valid
      end
      it do
        create(:assignment, user_id: user.id, issue_id: issue.id)
        expect { build(:assignment, user_id: user.id, issue_id: issue.id).save!(validate: false) }.to raise_error ActiveRecord::RecordNotUnique
      end
    end
    context "when invalid id" do
      let!(:issue) { create(:issue) }
      let!(:user) { create(:user) }
      it { expect(build(:assignment, user_id: user.id + 1, issue_id: issue.id)).to_not be_valid }
      it { expect(build(:assignment, user_id: user.id, issue_id: issue.id + 1)).to_not be_valid }
    end
  end
end
