require 'rails_helper'

RSpec.describe GroupUsersController, type: :controller do
  shared_examples 'return_not_found_response' do
    it 'return not found response' do
      expect(response).to have_http_status :not_found

      body = JSON.parse(response.body)

      expect(body).to include('message', 'status' => 'ng', 'error_code' => 404)
    end
  end

  describe '#show' do
    context 'when the specified group exists' do
      let!(:user) { create(:user) }
      let!(:group) { create(:group).tap { |group| group.user_ids = [user.id] } }

      subject(:response) { get :show, params: { group_id: group.id } }

      it 'return ok and user list' do
        expect(response).to have_http_status :ok

        body = JSON.parse(response.body)

        expect(body).to include('payload', 'status' => 'ok')

        returned_users = body['payload']

        expect(returned_users).to be_an(Array)
        expect(returned_users.first).to include('id' => user.id)
      end
    end

    context 'when the specified group does not exists' do
      subject(:response) { get :show, params: { group_id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end

  describe '#update' do
    context 'when the specified group exists' do
      let(:user) { create(:user) }
      let(:substitute_user) { create(:user) }
      let(:group) { create(:group).tap { |group| group.user_ids = [user.id] } }

      subject(:response) { put :update, params: group_attrs }

      context 'when parameters are valid' do
        let(:group_attrs) do
          {
            'group_id' => group.id,
            'group' => {
              'user_ids' => [substitute_user.id]
            }
          }
        end

        it 'update group and return ok' do
          expect(response).to have_http_status :ok

          body = JSON.parse(response.body)

          expect(body).to include('payload', 'status' => 'ok')

          returned_users = body['payload']

          expect(returned_users).to be_an(Array)
          expect(returned_users.first).to include('id' => substitute_user.id)
        end
      end
    end

    context 'when the specified group does not exists' do
      subject(:response) { put :update, params: { group_id: 9999 } }

      it_behaves_like 'return_not_found_response'
    end
  end
end
