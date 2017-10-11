require 'rails_helper'

RSpec.describe ApplicationController, :controller do
  describe "health" do
    subject { get :health }
    it { expect(subject.status).to eq 200 }
    it { expect(JSON.parse(subject.body)['status']).to eq 'ok' }
  end
end
