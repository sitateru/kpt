require 'rails_helper'

RSpec.describe UserGroupsController, type: :controller do
  shared_examples 'return_not_found_response' do
    it 'return not found response' do
      expect(response).to have_http_status :not_found

      body = JSON.parse(response.body)

      expect(body).to include('message', 'status' => 'ng', 'error_code' => 404)
    end
  end

  describe '#show' do
    context 'when the specified user exists' do
      let!(:group) { create(:group) }
      let!(:user) { create(:user).tap { |user| user.group_ids = [group.id] } }

      subject(:response) { get :show, params: { user_id: user.id } }

      it 'return ok and group list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_groups = body['payload']

        expect(returned_groups).to be_an(Array)
        expect(returned_groups.first).to include('id' => group.id)
      end
    end

    context 'when the specified user does not exists' do
      subject(:response) { get :show, params: { user_id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#update' do
    context 'when the specified user exists' do
      let(:group) { create(:group) }
      let(:substitute_group) { create(:group) }
      let(:user) { create(:user).tap { |user| user.group_ids = [group.id] } }

      subject(:response) { put :update, params: user_attrs }

      context 'when parameters are valid' do
        let(:user_attrs) do
          {
            'user_id' => user.id,
            'user' => {
              'group_ids' => [substitute_group.id]
            }
          }
        end

        it 'update user and return ok' do
          expect(response).to have_http_status :ok

          body = JSON.parse(response.body)

          expect(body).to include('payload', 'status' => 'ok')

          returned_groups = body['payload']

          expect(returned_groups).to be_an(Array)
          expect(returned_groups.first).to include('id' => substitute_group.id)
        end
      end
    end

    context 'when the specified group does not exists' do
      subject(:response) { put :update, params: { user_id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end
end
