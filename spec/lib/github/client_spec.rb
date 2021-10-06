# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Github::Client do
  subject { described_class.new(api_endpoint, token) }
  let(:api_endpoint) { 'https://api.test.test' }
  let(:token) { 'token' }
  let(:stub_endpoint) { URI.join(api_endpoint, 'search/repositories').to_s }
  let(:term) { 'ruby' }

  describe '#repositories' do
    let(:repositories) { fixture('repositories.json') }

    context 'with valid token' do
      before do
        stub_request(:get, stub_endpoint)
          .with(query: { q: term, per_page: 10, page: 1 })
          .to_return(status: 200, body: repositories.to_json)
      end

      it 'returns repositories' do
        result = subject.repositories(query: term)
        expect(result).to be_kind_of(Github::Response)
        expect(result.success?).to be true
        expect(result.data[:items]).to eq repositories['items']
      end
    end

    context 'with invalid token' do
      let(:response) { fixture('unauthorized.json') }

      before do
        stub_request(:get, stub_endpoint)
          .with(query: { q: term, per_page: 10, page: 1 })
          .to_return(status: 401, body: response.to_json)
      end

      it 'returns repositories' do
        result = subject.repositories(query: term)
        expect(result).to be_kind_of(Github::Response)
        expect(result.success?).to be false
        expect(result.error_message).to eq '401 Bad credentials'
      end
    end
  end
end
