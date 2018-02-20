require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  shared_examples 'status_is_ok' do
    it { expect(subject).to have_http_status :ok }
  end
  shared_examples 'status_is_bad_request' do
    it { expect(subject).to have_http_status :bad_request }
  end

  describe '#index' do
    let!(:user) { create(:user) }
    let!(:issue) { create(:issue) }
    let!(:issue_deleted) { create(:issue) }
    let!(:assignment) { create(:assignment, user_id: user.id, issue_id: issue.id) }
    let!(:assignment_refer_deleted_issue) { create(:assignment, user_id: user.id, issue_id: issue_deleted.id) }
    before { issue.destroy }
    subject { get :index }
    it_behaves_like 'status_is_ok'
    it { expect(JSON.parse(subject.body)['payload'].map { |d| d['id'] }).to include user.id }
    it { expect(JSON.parse(subject.body)['payload'].select { |d| d['id'] == user.id }[0]['issues'][0]['id']).to eq issue.id }
    it { expect(JSON.parse(subject.body)['payload'].select { |d| d['id'] == user.id }[0]['issues'][1]['id']).to eq issue_deleted.id }
  end
  describe '#show' do
    let!(:user) { create(:user) }
    subject { get :show, params: { id: user.id } }
    it_behaves_like 'status_is_ok'
    it { expect(JSON.parse(subject.body)['payload']['id']).to eq user.id }
  end

  describe '#create' do
    context 'ok' do
      let!(:user_attrs) { attributes_for(:user).keep_if { |k, _v| k =~ /name|email/ } }
      subject { post :create, params: { user: user_attrs } }
      it_behaves_like 'status_is_ok'
      it do
        expect(JSON.parse(subject.body)['payload']['name']).to eq user_attrs[:name]
        expect(JSON.parse(get(:index).body)['payload'].map { |d| d['name'] }).to include user_attrs[:name]
      end
    end
    context 'ng' do
      let!(:user_attrs) { attributes_for(:user, email: 'incorrect_address').keep_if { |k, _v| k =~ /name|email/ } }
      subject { post :create, params: { user: user_attrs } }
      it_behaves_like 'status_is_bad_request'
      it do
        expect(JSON.parse(subject.body)['status']).to eq 'ng'
        expect(JSON.parse(subject.body)['error_code']).to eq 400
        expect(JSON.parse(subject.body)['message']).to_not be_empty
        expect(JSON.parse(get(:index).body)['payload'].map { |d| d['name'] }).to_not include user_attrs[:name]
      end
    end
  end

  describe '#update' do
    context 'ok' do
      let!(:user) { create(:user) }
      let!(:user_attrs_updated) { attributes_for(:user, name: 'hanako').keep_if { |k, _v| k =~ /name|email/ } }
      subject { put :update, params: { id: user.id, user: user_attrs_updated } }
      it_behaves_like 'status_is_ok'
      it do
        expect(JSON.parse(subject.body)['payload']['id']).to eq user.id
        expect(JSON.parse(get(:show, params: { id: user.id }).body)['payload']['name']).to eq user_attrs_updated[:name]
      end
    end
    context 'ng' do
      let!(:user_already_exists) { create(:user) }
      let!(:user) { create(:user, name: 'taro') }
      let!(:user_attrs_updated) { attributes_for(:user, name: user_already_exists.name).keep_if { |k, _v| k =~ /name|email/ } }
      subject { put :update, params: { id: user.id, user: user_attrs_updated } }
      it_behaves_like 'status_is_bad_request'
      it do
        expect(JSON.parse(subject.body)['status']).to eq 'ng'
        expect(JSON.parse(subject.body)['error_code']).to eq 400
        expect(JSON.parse(subject.body)['message']).to_not be_empty
        expect(JSON.parse(get(:show, params: { id: user.id }).body)['payload']['name']).to eq user.name
      end
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }
    subject { delete :destroy, params: { id: user.id } }
    it_behaves_like 'status_is_ok'
    it do
      expect(JSON.parse(subject.body)['payload']['id']).to eq user.id
      expect(JSON.parse(get(:index).body)['payload'].map { |d| d['id'] }).to_not include user.id
    end
  end
end
