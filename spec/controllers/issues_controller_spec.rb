
require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  shared_examples 'status_is_ok' do
    it { expect(subject).to have_http_status :ok }
  end

  shared_examples 'status_is_bad_request' do
    it { expect(subject).to have_http_status :bad_request }
  end

  describe '#index' do
    context 'default' do
      let!(:tag) { create :tag }
      let!(:issue) { create(:issue).tap { |issue| issue.tag_ids = [tag.id] } }
      let!(:user) { create :user }
      let!(:user_deleted) { create(:user, name: 'deleted_user') }
      let!(:assignment) { create(:assignment, user_id: user.id, issue_id: issue.id) }
      let!(:assignment_refer_deleted_user) { create(:assignment, user_id: user_deleted.id, issue_id: issue.id) }
      before { user_deleted.destroy }
      subject { get :index }
      it_behaves_like 'status_is_ok'
      it { expect(JSON.parse(subject.body)['payload'].map { |d| d['id'] }).to include issue.id }
      it { expect(JSON.parse(subject.body)['payload'].select { |d| d['id'] == issue.id }[0]['users'][0]['id']).to eq user.id }
      it { expect(JSON.parse(subject.body)['payload'].select { |d| d['id'] == issue.id }[0]['users'][1]['id']).to eq user_deleted.id }
      it { expect(JSON.parse(subject.body)['payload'].select { |d| d['id'] == issue.id }[0]['tags'][0]['id']).to eq tag.id }
    end
    context 'filter by status' do
      let!(:issues_searched) { create_list :issue, 10, title: 'the string to be searched', status: :keep }
      subject { get :index, params: { q: { status_eq: 'keep', title_cont: 'to be searched' } } }
      it_behaves_like 'status_is_ok'
      it { expect(JSON.parse(subject.body)['payload'].count).to be >= 10 }
      it { expect(JSON.parse(subject.body)['payload'].map { |d| d['status'] }).to all(eq 'keep') }
      it { expect(JSON.parse(subject.body)['payload'].map { |d| d['title'] }).to all(include 'to be searched') }
    end
    context 'order by updated time' do
      let!(:issue_latest) { create_list(:issue, 10).last }
      subject { get :index, params: { q: { s: ['updated_at desc'] } } }
      it_behaves_like 'status_is_ok'
      it { expect(JSON.parse(subject.body)['payload'].first['id']).to eq issue_latest.id }
    end
  end

  describe '#create' do
    context '正常登録' do
      let(:issue_attrs) { attributes_for(:issue).keep_if { |k, _v| k =~ /body|title|status/ } }
      subject { put :create, params: { issue: issue_attrs } }
      it_behaves_like 'status_is_ok'
      it { expect(JSON.parse(subject.body)['payload']['body']).to eq issue_attrs[:body] }
    end

    context 'タイトルの必須NG' do
      let(:issue_attrs) { attributes_for(:issue).keep_if { |k, _v| k =~ /body|status/ } }
      subject { put :create, params: { issue: issue_attrs } }
      it_behaves_like 'status_is_bad_request'
      it { expect(JSON.parse(subject.body)['status']).to eq 'ng' }
      it { expect(JSON.parse(subject.body)['error_code']).to eq 400 }
      it { expect(JSON.parse(subject.body)['message']['title']).to eq ["can't be blank"] }
    end
  end

  describe '#update' do
    let(:issue_attrs) { create(:issue) }
    let(:issue_update_attrs) { attributes_for(:issue_update) }
    subject { patch :update, params: { id: issue_attrs, issue: issue_update_attrs } }
    it { expect(subject.status).to eq 200 }
    it { expect(JSON.parse(subject.body)['payload']['body']).to eq issue_update_attrs[:body] }
  end

  describe '#destroy' do
    let(:issue_attrs) { create(:issue) }
    let(:issue) { delete :destroy, params: { id: issue_attrs } }
    subject { get :index }
    it { expect(JSON.parse(subject.body)['payload'].map { |d| d['id'] }).not_to include issue_attrs[:id] }
  end

  describe '#open' do
    let(:issue) { create(:issue) }
    subject { patch :open, params: { id: issue } }
    it { expect(subject.status).to eq 200 }
    it { expect(JSON.parse(subject.body)['payload']['is_closed']).to eq false }
  end

  describe '#close' do
    let(:issue) { create(:issue) }
    subject { patch :close, params: { id: issue } }
    it { expect(subject.status).to eq 200 }
    it { expect(JSON.parse(subject.body)['payload']['is_closed']).to eq true }
  end
end
