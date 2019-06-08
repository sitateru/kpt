require 'rails_helper'

RSpec.describe IssueTagsController, type: :controller do
  shared_examples 'return_not_found_response' do
    it 'return not found response' do
      expect(response).to have_http_status :not_found

      body = JSON.parse(response.body)

      expect(body).to include('message', 'status' => 'ng', 'error_code' => 404)
    end
  end

  describe '#show' do
    context 'when the specified issue exists' do
      let!(:tag) { create(:tag) }
      let!(:issue) { create(:issue).tap { |issue| issue.tag_ids = [tag.id] } }

      subject(:response) { get :show, params: { issue_id: issue.id } }

      it 'return ok and tag list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_tags = body['payload']

        expect(returned_tags).to be_an(Array)
        expect(returned_tags.first).to include('id' => tag.id)
      end
    end

    context 'when the specified issue does not exists' do
      subject(:response) { get :show, params: { issue_id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#update' do
    context 'when the specified issue exists' do
      let(:tag) { create(:tag) }
      let(:substitute_tag) { create(:tag) }
      let(:issue) { create(:issue).tap { |issue| issue.tag_ids = [tag.id] } }

      subject(:response) { put :update, params: issue_attrs }

      context 'when parameters are valid' do
        let(:issue_attrs) do
          {
            'issue_id' => issue.id,
            'issue' => {
              'tag_ids' => [substitute_tag.id]
            }
          }
        end

        it 'update issue and return ok' do
          expect(response).to have_http_status :ok

          body = JSON.parse(response.body)

          expect(body).to include('payload', 'status' => 'ok')

          returned_tags = body['payload']

          expect(returned_tags).to be_an(Array)
          expect(returned_tags.first).to include('id' => substitute_tag.id)
        end
      end
    end

    context 'when the specified tag does not exists' do
      subject(:response) { put :update, params: { issue_id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end
end
