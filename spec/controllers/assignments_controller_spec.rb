require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  shared_examples 'status_is_ok' do
    it { expect(subject).to have_http_status :ok }
  end

  shared_examples 'status_is_bad_request' do
    it { expect(subject).to have_http_status :bad_request }
  end

  describe "#index" do
    let!(:issue) { create(:issue) }
    let!(:user) { create(:user) }
    let!(:assignment) { create(:assignment, user_id: user.id, issue_id: issue.id) }
    subject { get :index }
    it_behaves_like 'status_is_ok'
    it { expect(JSON.parse(subject.body)['payload'].map { |d| d['id'] }).to include assignment.id }
    it { expect(JSON.parse(subject.body)['payload'].map { |d| d['user']['id'] }).to include user.id }
    it { expect(JSON.parse(subject.body)['payload'].map { |d| d['issue']['id'] }).to include issue.id }
  end

  describe "#create" do
    context "ok" do
      let!(:issue) { create(:issue) }
      let!(:user) { create(:user) }
      subject { post :create, params: { user_id: user.id, issue_id: issue.id } }
      it_behaves_like 'status_is_ok'
      it do
        expect(JSON.parse(subject.body)['payload']['user_id']).to eq user.id
        expect(JSON.parse(subject.body)['payload']['issue_id']).to eq issue.id
        expect(JSON.parse(get(:index).body)['payload'].map { |d| d['user']['id'] }).to include user.id
      end
    end
    context "ng" do
      let!(:issue) { create(:issue) }
      let!(:user) { create(:user) }
      subject { post :create, params: { user_id: user.id, issue_id: nil } }
      it_behaves_like 'status_is_bad_request'
      it do
        expect(JSON.parse(subject.body)['status']).to eq "ng"
        expect(JSON.parse(subject.body)['error_code']).to eq 400
        expect(JSON.parse(subject.body)['message']).to_not be_empty
        expect(JSON.parse(get(:index).body)['payload'].map { |d| d['user']['id'] }).to_not include user.id
      end
    end
  end

  describe "#destroy" do
    let!(:issue) { create(:issue) }
    let!(:user) { create(:user) }
    let!(:assignment) { create(:assignment, user_id: user.id, issue_id: issue.id) }
    subject { delete :destroy, params: { id: assignment.id } }
    it_behaves_like 'status_is_ok'
    it do
      expect(JSON.parse(subject.body)['payload']['id']).to eq assignment.id
      expect(JSON.parse(get(:index).body)['payload'].map { |d| d['id'] }).to_not include assignment.id
    end
  end
end
