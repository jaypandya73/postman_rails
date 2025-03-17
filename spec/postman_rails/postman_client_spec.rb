require 'spec_helper'

RSpec.describe PostmanRails::PostmanClient do
  let(:api_key) { 'test_api_key' }
  let(:collection_id) { '12345678-1234-1234-1234-123456789012' }
  let(:client) { PostmanRails::PostmanClient.new(api_key) }
  
  before do
    # Configure PostmanRails with default values
    PostmanRails.configure do |config|
      config.api_key = 'default_api_key'
      config.collection_id = 'default_collection_id'
    end
  end
  
  describe '#initialize' do
    it 'uses the provided API key' do
      client = PostmanRails::PostmanClient.new(api_key)
      expect(client.instance_variable_get(:@api_key)).to eq(api_key)
    end
    
    it 'falls back to the configured API key if none is provided' do
      client = PostmanRails::PostmanClient.new
      expect(client.instance_variable_get(:@api_key)).to eq('default_api_key')
    end
  end
  
  describe '#list_collections' do
    before do
      stub_request(:get, "https://api.getpostman.com/collections")
        .with(headers: { 'X-Api-Key' => api_key })
        .to_return(status: 200, body: fixture('collections.json'))
    end
    
    it 'returns a list of collections' do
      collections = client.list_collections
      
      expect(collections).to be_an(Array)
      expect(collections.size).to eq(2)
      expect(collections.first['name']).to eq('Test Collection 1')
    end
  end
  
  describe '#get_collection' do
    before do
      stub_request(:get, "https://api.getpostman.com/collections/#{collection_id}")
        .with(headers: { 'X-Api-Key' => api_key })
        .to_return(status: 200, body: fixture('collection.json'))
    end
    
    it 'returns a specific collection' do
      collection = client.get_collection(collection_id)
      
      expect(collection).to be_a(Hash)
      expect(collection['info']['name']).to eq('Test Collection')
      expect(collection['item'].size).to eq(1)
    end
  end
  
  describe '#create_collection' do
    let(:name) { 'New Collection' }
    let(:description) { 'A new collection' }
    
    before do
      stub_request(:post, "https://api.getpostman.com/collections")
        .with(
          headers: { 
            'X-Api-Key' => api_key,
            'Content-Type' => 'application/json'
          },
          body: {
            collection: {
              info: {
                name: name,
                description: description,
                schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
              },
              item: []
            }
          }.to_json
        )
        .to_return(status: 200, body: { collection: { id: collection_id, name: name } }.to_json)
    end
    
    it 'creates a new collection' do
      collection = client.create_collection(name, description)
      
      expect(collection).to be_a(Hash)
      expect(collection['id']).to eq(collection_id)
      expect(collection['name']).to eq(name)
    end
  end
  
  describe '#update_collection' do
    let(:collection_data) do
      {
        'info' => {
          'name' => 'Updated Collection',
          'schema' => "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        'item' => []
      }
    end
    
    before do
      stub_request(:put, "https://api.getpostman.com/collections/#{collection_id}")
        .with(
          headers: { 
            'X-Api-Key' => api_key,
            'Content-Type' => 'application/json'
          },
          body: { collection: collection_data }.to_json
        )
        .to_return(status: 200, body: { collection: { id: collection_id } }.to_json)
    end
    
    it 'updates a collection' do
      response = client.update_collection(collection_id, collection_data)
      
      expect(response).to be_a(Hash)
      expect(response['collection']['id']).to eq(collection_id)
    end
  end
  
  describe '#list_environments' do
    before do
      stub_request(:get, "https://api.getpostman.com/environments")
        .with(headers: { 'X-Api-Key' => api_key })
        .to_return(status: 200, body: fixture('environments.json'))
    end
    
    it 'returns a list of environments' do
      environments = client.list_environments
      
      expect(environments).to be_an(Array)
      expect(environments.size).to eq(2)
      expect(environments.first['name']).to eq('Development')
    end
  end
  
  describe '#get_environment' do
    let(:environment_id) { '11111111-1111-1111-1111-111111111111' }
    
    before do
      stub_request(:get, "https://api.getpostman.com/environments/#{environment_id}")
        .with(headers: { 'X-Api-Key' => api_key })
        .to_return(status: 200, body: fixture('environment.json'))
    end
    
    it 'returns a specific environment' do
      environment = client.get_environment(environment_id)
      
      expect(environment).to be_a(Hash)
      expect(environment['name']).to eq('Development')
      expect(environment['values'].size).to eq(2)
    end
  end
  
  describe 'error handling' do
    before do
      stub_request(:get, "https://api.getpostman.com/collections")
        .with(headers: { 'X-Api-Key' => api_key })
        .to_return(status: 401, body: { error: { message: "Invalid API Key" } }.to_json)
    end
    
    it 'raises an error for unsuccessful responses' do
      expect { client.list_collections }.to raise_error(PostmanRails::Error, /Postman API error: 401/)
    end
  end
end 
