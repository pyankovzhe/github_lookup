# frozen_string_literal: true

require 'spec_helper'

RSpec.describe App do
  def app
    App
  end

  let(:api_endpoint) { 'https://api.test.test' }
  let(:token) { 'token' }

  describe 'GET /' do
    it 'renders home page with search form' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Github repo viewer')
    end
  end

  describe 'GET repositories' do
    let(:repositories) { fixture('repositories.json') }
    let(:client_mock)  { instance_double(Github::Client) }
    let(:response_mock) { instance_double(Github::Response) }
    let(:term) { 'ruby' }

    before do
      allow(Github::Client).to receive(:new).and_return(client_mock)
      allow(client_mock).to receive(:repositories).with(query: term).and_return(response_mock)
    end

    context 'with successful response' do
      before do
        allow(response_mock).to receive(:success?).and_return(true)
        allow(response_mock).to receive(:data).and_return(repositories.transform_keys(&:to_sym))
      end

      it 'renders repositories' do
        get "/repositories?q=#{term}"
        expect(last_response).to be_ok
        repositories_names = repositories['items'].map { |repo| repo['full_name'] }
        expect(last_response.body).to include(*repositories_names)
      end
    end

    context 'with failed response' do
      let(:error_message) { '400 Bad request' }

      before do
        allow(response_mock).to receive(:success?).and_return(false)
        allow(response_mock).to receive(:error_message).and_return(error_message)
      end

      it 'renders errors' do
        get "/repositories?q=#{term}"
        follow_redirect!
        expect(last_response).to be_ok
        expect(last_response.body).to include error_message
      end
    end
  end
end
