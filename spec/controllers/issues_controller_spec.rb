require 'rails_helper'

RSpec.describe IssuesController, type: :controller do

  shared_examples 'status_is_ok' do
    it { expect(subject.status).to eq 200 }
  end

  describe "#index" do
    let!(:issue) { create :issue }
    subject { get :index }
    it_behaves_like 'status_is_ok'
    it { expect(JSON.parse(subject.body)['payload'].map{ |d| d['id'] }).to include issue.id}
  end

  describe "#create" do
    context '正常登録' do
      let(:issue_attrs) {  FactoryGirl.attributes_for(:issue).keep_if { |k, v| k =~ /body|title|status/ } }
      subject { put :create, params: issue_attrs }
      it_behaves_like 'status_is_ok'
      it { expect(JSON.parse(subject.body)['payload']['body']).to eq issue_attrs[:body] }
    end

    context 'タイトルの必須NG' do
      let(:issue_attrs) {  FactoryGirl.attributes_for(:issue).keep_if { |k, v| k =~ /body|status/ } }
      subject { put :create, params: issue_attrs }
      it_behaves_like 'status_is_ok'
      it { expect(JSON.parse(subject.body)['status']).to eq 'ng' }
      it { expect(JSON.parse(subject.body)['error_code']).to eq 400 }
      it { expect(JSON.parse(subject.body)['message']['title']).to eq ["can't be blank"]}
    end
  end
end
