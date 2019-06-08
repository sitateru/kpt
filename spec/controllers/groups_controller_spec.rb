require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
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

    context 'when there is no group' do
      it 'return ok and empty group list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body['status']).to eq 'ok'
        expect(body['payload']).to be_an(Array)
        expect(body['payload']).to be_empty
      end
    end

    context 'when there is one group with user' do
      let!(:user) { create(:user) }
      let!(:group) { create(:group).tap { |group| group.user_ids = [user.id] } }

      it 'return ok and group list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body['status']).to eq 'ok'
        expect(body['payload']).to be_an(Array)

        returned_group = body['payload'].find do |inner|
          inner['id'] == group.id
        end

        expect(returned_group).to be_present
        expect(returned_group['users']).to be_an(Array)
        expect(returned_group['users']).to be_present

        returned_user = returned_group['users'].find do |inner|
          inner['id'] == user.id
        end

        expect(returned_user).to be_present
      end
    end
  end

  describe '#show' do
    context 'when the specified group exists' do
      let!(:user) { create(:user) }
      let!(:group) { create(:group).tap { |group| group.user_ids = [user.id] } }

      subject(:response) { get :show, params: { id: group.id } }

      it 'return ok and group data' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_group = body['payload']

        expect(returned_group).to be_present
        expect(returned_group['users']).to be_an(Array)
        expect(returned_group['users']).to be_present

        returned_user = returned_group['users'].find do |inner|
          inner['id'] == user.id
        end

        expect(returned_user).to be_present
      end
    end

    context 'when the specified group does not exists' do
      subject(:response) { get :show, params: { id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#create' do
    subject(:response) { post :create, params: group_attrs }

    context 'when parameters are valid' do
      let(:user) { create(:user) }
      let(:group_attrs) do
        {
          'group' => {
            'name' => 'foo'
          }
        }
      end

      it 'create group and return ok' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_group = body['payload']

        expect(returned_group).to be_present
        expect(returned_group['users']).to be_an(Array)
        expect(returned_group['users']).to be_empty
      end
    end

    context 'when parameters are invalid' do
      let(:group_attrs) do
        {
          'group' => {
            'name' => ''
          }
        }
      end

      it_behaves_like 'return_bad_request_response'
    end
  end

  describe '#update' do
    context 'when the specified group exists' do
      let(:user) { create(:user) }
      let(:substitute_user) { create(:user) }
      let(:group) { create(:group).tap { |group| group.user_ids = [user.id] } }

      subject(:response) { put :update, params: group_attrs }

      context 'when parameters are valid' do
        let(:group_attr_name) { 'bar' }
        let(:group_attrs) do
          {
            'id' => group.id,
            'group' => {
              'name' => group_attr_name
            }
          }
        end

        it 'update group and return ok' do
          expect(response).to have_http_status :ok

          body = JSON.parse(response.body)

          expect(body).to include('payload', 'status' => 'ok')

          returned_group = body['payload']

          expect(returned_group).to be_present
          expect(returned_group['name']).to eq group_attr_name

          expect(returned_group['users']).to be_an(Array)
          expect(returned_group['users'][0]).to include('id' => user.id)

          expect(Group.find(group.id)).to have_attributes(name: group_attr_name)
        end
      end

      context 'when parameters are invalid' do
        let(:group_attrs) do
          {
            'id' => group.id,
            'group' => {
              'name' => ''
            }
          }
        end

        it_behaves_like 'return_bad_request_response'
      end
    end

    context 'when the specified group does not exists' do
      subject(:response) { put :update, params: { id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#destroy' do
    context 'when specified group exists' do
      let(:user) { create(:user) }
      let(:group) { create(:group).tap { |group| group.user_ids = [user.id] } }

      subject(:response) { delete :destroy, params: { id: group.id } }

      it 'delete group and return ok' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_group = body['payload']

        expect(returned_group).to be_present

        expect { Group.find(group.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when specified group does not exists' do
      subject(:response) { delete :destroy, params: { id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end
end
