# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path 'users' do
    get 'list users' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'Authentication', in: :header, type: :string, default: 'Bearer token'

      response '200', 'ok' do
        schema type: :object,
               properties: {
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     username: { type: :string },
                     email: { type: :string, format: :email },
                     first_name: { type: :string },
                     last_name: { type: :string },
                     gender: { type: :integer },
                     birthdate: { type: :string, format: :date },
                     job_title: { type: :string },
                     phone_number: { type: :string, format: :number },
                     shipping_address: { type: :string },
                     billing_address: { type: :string },
                     shipping_postcode: { type: :string },
                     billing_postcode: { type: :string },
                     # IDs
                     billing_country_id: { type: :integer },
                     billing_state_id: { type: :integer },
                     billing_city_id: { type: :integer },
                     shipping_country_id: { type: :integer },
                     shipping_state_id: { type: :integer },
                     shipping_city_id: { type: :integer },
                     # Business info
                     business_name: { type: :string },
                     legal_form: { type: :integer },
                     business_reg_num: { type: :string },
                     tax_id_num: { type: :string },
                     # Names
                     billing_country: { type: :integer },
                     billing_state: { type: :integer },
                     billing_city: { type: :integer },
                     shipping_country: { type: :integer },
                     shipping_state: { type: :integer },
                     shipping_city: { type: :integer }
                   }
                 }
               }
        run_test!
      end

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }

        run_test!
      end
    end

    delete 'delete a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'Authentication', in: :header, type: :string, default: 'Bearer token'
      parameter name: :id, in: :path, type: :string

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }

        run_test!
      end

      response '404', 'Record not found' do
        run_test!
      end

      response '400', 'you cannot delete yourself' do
        run_test!
      end

      response '422', 'Error happened during deleting the user' do
        run_test!
      end

      response '200', 'user deleted successfully' do
        run_test!
      end
    end
  end

  path 'users/archive/{id}' do
    post 'Archive a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'Authentication', in: :header, type: :string, default: 'Bearer token'
      parameter name: :id, in: :path, type: :string

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }

        run_test!
      end

      response '404', 'Record not found' do
        run_test!
      end

      response '400', 'user already archived or trying to archive himself' do
        run_test!
      end

      response '422', 'Error happened during archiving the user' do
        run_test!
      end

      response '200', 'user archived successfully' do
        run_test!
      end
    end
  end

  path 'users/unarchive/{id}' do
    post 'Unarchive a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'Authentication', in: :header, type: :string, default: 'Bearer token'
      parameter name: :id, in: :path, type: :string

      response '401', 'Un-Authorized' do
        let(:Authentication) { '' }

        run_test!
      end

      response '404', 'Record not found' do
        run_test!
      end

      response '400', 'user already unarchived or trying to unarchive himself' do
        run_test!
      end

      response '422', 'Error happened during unarchiving the user' do
        run_test!
      end

      response '200', 'user unarchived successfully' do
        run_test!
      end
    end
  end
end
