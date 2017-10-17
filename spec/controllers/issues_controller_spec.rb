require 'rails_helper'

RSpec.describe IssuesController, type: :controller do

  describe "#index" do
    let!(:issue) { create :issue }
    subject { get :index }
    it { expect(subject.status).to eq 200 }
    it { expect(JSON.parse(subject.body)['payload'].map{ |d| d['id'] }).to include issue.id}
  end

  describe "#create" do
    let(:issue_attrs) {  FactoryGirl.attributes_for(:issue).keep_if { |k, v| k =~ /body|title|status/ } }
    subject { put :create, params: { issue: issue_attrs } }
    it { expect(subject.status).to eq 200 }
    it { expect(JSON.parse(subject.body)['payload']['body']).to eq issue_attrs[:body] }
  end

  describe "#destroy" do
    let(:issue_attrs) {FactoryGirl.create(:issue)}
    let(:issue) {delete :destroy, params: {id: issue_attrs}}
    subject {get :index}
    it {expect(JSON.parse(subject.body)['payload'].map {|d| d['id']}).not_to include issue_attrs[:id]}
  end
end