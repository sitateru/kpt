require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation ok' do
    it { expect(build(:user)).to be_valid }
  end
  describe 'name validation' do
    context 'when recreate user' do
      before { create(:user, name: 'deleteduser').destroy }
      it { expect(User.where(name: 'deleteduser').count).to eq 0 }
      it { expect(User.with_deleted.where(name: 'deleteduser').count).to eq 1 }
      it { expect(build(:user, name: 'deleteduser')).to be_valid }
    end
    context 'when not unique' do
      before do
        create(:user, name: 'dupuser').destroy
        create(:user, name: 'dupuser')
        @user = build(:user, name: 'dupuser')
      end
      it do
        expect(@user).to_not be_valid
        expect(@user.errors[:name]).to_not be_empty
      end
      it { expect { @user.save!(validate: false) }.to raise_error ActiveRecord::RecordNotUnique }
    end
    context 'when blank' do
      let(:user) { build(:user, name: '') }
      it do
        expect(user).to_not be_valid
        expect(user.errors[:name]).to_not be_empty
      end
    end
  end
  describe 'email validation' do
    context 'when blank' do
      let(:user) { build(:user, email: '') }
      it do
        expect(user).to_not be_valid
        expect(user.errors[:email]).to_not be_empty
      end
    end
    context 'when incorrect' do
      let(:user) { build(:user, email: 'hogehoge') }
      it do
        expect(user).to_not be_valid
        expect(user.errors[:email]).to_not be_empty
      end
    end
  end
end
