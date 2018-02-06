require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe 'as a Guest' do
    let(:headers){ { 'accept' => 'application/json' } }

    it 'GET contacts' do
      get '/api/v1/contacts.json'
      expect(response).to have_http_status(401)
    end

    it 'GET contacts/1' do
      get '/api/v1/contacts/1.json'
      expect(response).to have_http_status(401)
    end

    it 'POST contacts' do
      contact_params = attributes_for(:contact)

      post '/api/v1/contacts.json', params: { contact: contact_params }, headers: headers
      expect(response).to have_http_status(401)
    end

    it 'PATCH/PUT contacts' do
      contact = Contact.first
      contact.name += 'Atualizado'

      patch "/api/v1/contacts/#{contact.id}.json", params: { contact: contact.attributes },
                                                   headers: headers
      expect(response).to have_http_status(401)
    end

    it 'DELETE contacts' do
      contact = Contact.first

      delete "/api/v1/contacts/#{contact.id}.json", headers: headers
      expect(response).to have_http_status(401)
    end
  end

  describe 'with Token' do
    before do
      @user = create(:user)
      @contact = create(:contact, user_id: @user.id)
    end

    it 'GET contacts' do
      get '/api/v1/contacts.json', headers: {'x-user-email' => @user.email,
                                                'x-user-token' => @user.authentication_token}

      expect(response).to have_http_status(200)
      expect(response).to match_response_schema('contacts')
    end

    it 'GET contacts - #show' do
      get "/api/v1/contacts/#{@contact.id}.json", headers: {'x-user-email' => @user.email,
                                                'x-user-token' => @user.authentication_token}

      expect(response).to have_http_status(200)
      expect(response).to match_response_schema('contact')
    end

    it 'POST contacts' do
      headers = { 'accept' => 'application/json',
                  'x-user-email' => @user.email,
                  'x-user-token' => @user.authentication_token }
      contact_params = attributes_for(:contact)

      post '/api/v1/contacts.json', params: { contact: contact_params }, headers: headers
      expect(response).to have_http_status(201) #created status
      expect(response).to match_response_schema('contact')
    end

    it 'PATCH/PUT contacts' do
      headers = { 'accept' => 'application/json',
                  'x-user-email' => @user.email,
                  'x-user-token' => @user.authentication_token }
      @contact.name += 'Atualizado'

      patch "/api/v1/contacts/#{@contact.id}.json", params: { contact: @contact.attributes },
                                                   headers: headers
      expect(response).to have_http_status(200)
      expect(response).to match_response_schema('contact')
    end

    it 'DELETE contacts' do
      headers = { 'accept' => 'application/json',
                  'x-user-email' => @user.email,
                  'x-user-token' => @user.authentication_token }

      expect{
          delete "/api/v1/contacts/#{@contact.id}.json", headers: headers
        }.to change(Contact, :count).by(-1)

      expect(response).to have_http_status(204)
    end
  end

  describe 'testing contacts with other owner' do
    before do
      @user = create(:user)
      @otheruser = create(:user)
      @contact = create(:contact, user: @otheruser)
      @headers = { 'accept' => 'application/json',
                  'x-user-email' => @user.email,
                  'x-user-token' => @user.authentication_token }
    end

    it 'GET contacts - #show' do
      get "/api/v1/contacts/#{@contact.id}.json", headers: @headers

      expect(response).to have_http_status(403)
    end

    it 'PATCH/PUT contacts' do
      patch "/api/v1/contacts/#{@contact.id}.json", params: { contact: @contact.attributes },
                                                   headers: @headers
      expect(response).to have_http_status(403)
    end

    it 'DELETE contacts' do
      delete "/api/v1/contacts/#{@contact.id}.json", headers: @headers
      expect(response).to have_http_status(403)
    end
  end

  describe 'with invalid token' do
    before do
      @user = create(:user)
      @contact = create(:contact)
      headers = { 'accept' => 'application/json',
                  'x-user-email' => @user.email,
                  'x-user-token' => 'foo' }
    end

    it 'GET contacts' do
      get '/api/v1/contacts.json', headers: @headers

      expect(response).to have_http_status(401)
    end

    it 'GET contacts - #show' do
      get "/api/v1/contacts/#{@contact.id}.json", headers: @headers

      expect(response).to have_http_status(401)
    end

    it 'POST contacts' do
      contact_params = attributes_for(:contact)

      post '/api/v1/contacts.json', params: { contact: contact_params }, headers: @headers
      expect(response).to have_http_status(401)
    end

    it 'PATCH/PUT contacts' do
      headers = { 'accept' => 'application/json',
                  'x-user-email' => @user.email,
                  'x-user-token' => @user.authentication_token }
      @contact.name += 'Atualizado'

      patch "/api/v1/contacts/#{@contact.id}.json", params: { contact: @contact.attributes },
                                                   headers: @headers
      expect(response).to have_http_status(401)
    end

    it 'DELETE contacts' do
      delete "/api/v1/contacts/#{@contact.id}.json", headers: @headers

      expect(response).to have_http_status(401)
    end

  end
end
