require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe "title validate" do
    subject { build(:issue, title: '') }
    it {expect(subject).not_to be_valid}
  end
end