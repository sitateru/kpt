require 'rails_helper'

RSpec.describe GroupUser, type: :model do
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  context 'when group id and user id are valid' do
    subject { build(:group_user, user_id: user.id, group_id: group.id) }
    it { is_expected.to be_valid }
  end

  context 'when the pair of ids is not unique' do
    before do
      create(:group_user, user_id: user.id, group_id: group.id)
    end

    context 'create model instance' do
      subject { build(:group_user, user_id: user.id, group_id: group.id) }
      it { is_expected.to_not be_valid }
    end

    context 'create model instance and save' do
      let(:group_user) do
        build(:group_user, user_id: user.id, group_id: group.id)
      end

      it { expect { group_user.save!(validate: false) }.to raise_error ActiveRecord::RecordNotUnique }
    end
  end

  context 'when there is no record with specified id' do
    context 'does not exists in the users table' do
      subject { build(:group_user, user_id: user.id + 1, group_id: group.id) }
      it { is_expected.to_not be_valid }
    end

    context 'does not exists in the groups table' do
      subject { build(:group_user, user_id: user.id, group_id: group.id + 1) }
      it { is_expected.to_not be_valid }
    end
  end
end
