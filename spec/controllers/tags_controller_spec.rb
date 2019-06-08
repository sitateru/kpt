require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  shared_examples 'return_not_found_response' do
    it 'return not found response' do
      expect(response).to have_http_status :not_found

      body = JSON.parse(response.body)

      expect(body).to include('message', 'status' => 'ng', 'error_code' => 404)
    end
  end

  shared_examples 'return_bad_request_response' do
    it 'return bad request response' do
      expect(response).to have_http_status :bad_request

      body = JSON.parse(response.body)

      expect(body).to include('message', 'status' => 'ng', 'error_code' => 400)
    end
  end

  describe '#index' do
    subject(:response) { get :index }

    context 'when there is no tag' do
      it 'return ok and empty tag list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body['status']).to eq 'ok'
        expect(body['payload']).to be_an(Array)
        expect(body['payload']).to be_empty
      end
    end

    context 'when there is one tag with issue' do
      let!(:tag) { create(:tag) }

      it 'return ok and tag list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body['status']).to eq 'ok'
        expect(body['payload']).to be_an(Array)

        returned_tag = body['payload'].find do |inner|
          inner['id'] == tag.id
        end

        expect(returned_tag).to be_present
      end
    end
  end

  describe '#show' do
    context 'when the specified tag exists' do
      let!(:tag) { create(:tag) }

      subject(:response) { get :show, params: { id: tag.id } }

      it 'return ok and tag data' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_tag = body['payload']

        expect(returned_tag).to be_present
        expect(returned_tag['id']).to eq tag.id
      end
    end

    context 'when the specified tag does not exists' do
      subject(:response) { get :show, params: { id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#create' do
    subject(:response) { post :create, params: tag_attrs }

    context 'when parameters are valid' do
      let(:tag_attrs) do
        {
          'tag' => {
            'name' => 'foo'
          }
        }
      end

      it 'create tag and return ok' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_tag = body['payload']

        expect(returned_tag).to be_present
      end
    end

    context 'when parameters are invalid' do
      let(:tag_attrs) do
        {
          'tag' => {
            'name' => ''
          }
        }
      end

      it_behaves_like 'return_bad_request_response'
    end
  end

  describe '#update' do
    context 'when the specified tag exists' do
      let(:tag) { create(:tag) }

      subject(:response) { put :update, params: tag_attrs }

      context 'when parameters are valid' do
        let(:tag_attr_name) { 'bar' }
        let(:tag_attrs) do
          {
            'id' => tag.id,
            'tag' => {
              'name' => tag_attr_name
            }
          }
        end

        it 'update tag and return ok' do
          expect(response).to have_http_status :ok

          body = JSON.parse(response.body)

          expect(body).to include('payload', 'status' => 'ok')

          returned_tag = body['payload']

          expect(returned_tag).to be_present
          expect(returned_tag['name']).to eq tag_attr_name

          expect(Tag.find(tag.id)).to have_attributes(name: tag_attr_name)
        end
      end

      context 'when parameters are invalid' do
        let(:tag_attrs) do
          {
            'id' => tag.id,
            'tag' => {
              'name' => ''
            }
          }
        end

        it_behaves_like 'return_bad_request_response'
      end
    end

    context 'when the specified tag does not exists' do
      subject(:response) { put :update, params: { id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#destroy' do
    context 'when specified tag exists' do
      let(:tag) { create(:tag) }

      subject(:response) { delete :destroy, params: { id: tag.id } }

      it 'delete tag and return ok' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_tag = body['payload']

        expect(returned_tag).to be_present

        expect { Tag.find(tag.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when specified tag does not exists' do
      subject(:response) { delete :destroy, params: { id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end
end
