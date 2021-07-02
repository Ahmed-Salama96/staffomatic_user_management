# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { User.create(
    email: 'danie@example.com',
    password: 'supersecurepassword',
    password_confirmation: 'supersecurepassword',
    ) }
  let!(:unarchived_user) { User.create(
    email: 'anna@example.com',
    password: 'secure_password',
    password_confirmation: 'secure_password',
    ) }

  let!(:archived_user) { User.create(
    email: 'emi@example.com',
    password: 'secure_password',
    password_confirmation: 'secure_password',
    is_archived: true
    ) }

  let(:Authentication) { 'Bearer ' +  authenticate_user(user) }

  path '/users' do
    get 'list users' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authentication, in: :header, type: :string, default: 'Bearer token'
      parameter name: :status, in: :path, type: :string, required: false

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }
        run_test!
      end

      response '200', 'ok' do
        let(:status) { 'unarchived' }

        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string, format: :email },
                     created_at: { type: :string, format: :date_time },
                     updated_at: { type: :string, format: :date_time },
                     deleted_at: { type: :string, format: :date_time },
                     is_archived: { type: :boolean }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/users/{id}' do
    delete 'delete a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authentication, in: :header, type: :string, default: 'Bearer token'
      parameter name: :id, in: :path, type: :string

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }
        let(:id) { user.id }

        run_test!
      end

      response '404', 'Record not found' do
        let(:id) { 'invalid' }

        run_test!
      end

      response '400', 'you cannot delete yourself' do
        let(:id) { user.id }

        run_test!
      end

      response '200', 'user deleted successfully' do
        let(:id) { unarchived_user.id }

        run_test!
      end
    end
  end

  path '/users/archive/{id}' do
    post 'Archive a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authentication, in: :header, type: :string, default: 'Bearer token'
      parameter name: :id, in: :path, type: :string

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }
        let(:id) { user.id }

        run_test!
      end

      response '404', 'Record not found' do
        let(:id) { 'invalid' }

        run_test!
      end

      response '400', 'user already archived or trying to archive himself' do
        let(:id) { user.id }

        run_test!
      end

      response '200', 'user archived successfully' do
        let(:id) { unarchived_user.id }

        run_test!
      end
    end
  end

  path '/users/unarchive/{id}' do
    post 'Unarchive a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authentication, in: :header, type: :string, default: 'Bearer token'
      parameter name: :id, in: :path, type: :string

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }
        let(:id) { user.id }

        run_test!
      end

      response '404', 'Record not found' do
        let(:id) { 'invalid' }

        run_test!
      end

      response '400', 'user already unarchived or trying to unarchive himself' do
        let(:id) { user.id }

        run_test!
      end

      response '200', 'user unarchived successfully' do
        let(:id) { archived_user.id }

        run_test!
      end
    end
  end
end
