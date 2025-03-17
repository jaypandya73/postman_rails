# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PostmanRails do
  let(:client) { instance_double(PostmanRails::PostmanClient) }
  let(:sync) { instance_double(PostmanRails::Sync) }
  
  before do
    allow(PostmanRails::PostmanClient).to receive(:new).and_return(client)
    allow(PostmanRails::Sync).to receive(:new).and_return(sync)
  end
  
  describe '.client' do
    it 'returns a PostmanClient instance' do
      expect(PostmanRails.client).to eq(client)
    end
    
    it 'returns the same instance on multiple calls' do
      client1 = PostmanRails.client
      client2 = PostmanRails.client
      
      expect(client1).to be(client2)
    end
  end
  
  describe '.list_collections' do
    it 'delegates to the client' do
      expect(client).to receive(:list_collections)
      
      PostmanRails.list_collections
    end
  end
  
  describe '.get_collection' do
    let(:collection_id) { '12345678-1234-1234-1234-123456789012' }
    
    it 'delegates to the client with the provided collection ID' do
      expect(client).to receive(:get_collection).with(collection_id)
      
      PostmanRails.get_collection(collection_id)
    end
    
    it 'uses the configured collection ID if none is provided' do
      PostmanRails.configure do |config|
        config.collection_id = collection_id
      end
      
      expect(client).to receive(:get_collection).with(collection_id)
      
      PostmanRails.get_collection
    end
  end
  
  describe '.create_collection' do
    let(:name) { 'Test Collection' }
    let(:description) { 'A test collection' }
    
    it 'delegates to the client' do
      expect(client).to receive(:create_collection).with(name, description)
      
      PostmanRails.create_collection(name, description)
    end
  end
  
  describe '.list_environments' do
    it 'delegates to the client' do
      expect(client).to receive(:list_environments)
      
      PostmanRails.list_environments
    end
  end
  
  describe '.get_environment' do
    let(:environment_id) { '11111111-1111-1111-1111-111111111111' }
    
    it 'delegates to the client' do
      expect(client).to receive(:get_environment).with(environment_id)
      
      PostmanRails.get_environment(environment_id)
    end
  end
  
  describe '.sync_all' do
    it 'delegates to the sync instance' do
      expect(sync).to receive(:sync_all)
      
      PostmanRails.sync_all
    end
  end
  
  describe '.sync_controller' do
    let(:controller) { 'users' }
    
    it 'delegates to the sync instance' do
      expect(sync).to receive(:sync_controller).with(controller)
      
      PostmanRails.sync_controller(controller)
    end
  end
  
  describe '.sync_action' do
    let(:controller) { 'users' }
    let(:action) { 'index' }
    
    it 'delegates to the sync instance' do
      expect(sync).to receive(:sync_action).with(controller, action)
      
      PostmanRails.sync_action(controller, action)
    end
  end

  it "has a version number" do
    expect(PostmanRails::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
