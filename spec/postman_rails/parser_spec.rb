require 'spec_helper'

RSpec.describe PostmanRails::Parser do
  let(:parser) { PostmanRails::Parser.new }
  
  before do
    PostmanRails.configure do |config|
      config.api_docs_path = File.join(File.dirname(__FILE__), '..', 'fixtures')
    end
    
    # Stub Dir.glob to return our fixture file
    allow(Dir).to receive(:glob).with("#{PostmanRails.config.api_docs_path}/*.yml").and_return([fixture_path('users.yml')])
  end
  
  describe '#parse_all' do
    it 'parses all YAML files in the configured directory' do
      endpoints = parser.parse_all
      
      expect(endpoints).to be_an(Array)
      expect(endpoints.size).to eq(2)
      expect(endpoints.first[:controller]).to eq('users')
      expect(endpoints.first[:action]).to eq('index')
    end
  end
  
  describe '#parse_controller' do
    it 'parses a specific controller file' do
      allow(File).to receive(:exist?).with("#{PostmanRails.config.api_docs_path}/users.yml").and_return(true)
      
      endpoints = parser.parse_controller('users')
      
      expect(endpoints).to be_an(Array)
      expect(endpoints.size).to eq(2)
      expect(endpoints.first[:controller]).to eq('users')
      expect(endpoints.map { |e| e[:action] }).to contain_exactly('index', 'show')
    end
    
    it 'returns an empty array if the controller file does not exist' do
      allow(File).to receive(:exist?).with("#{PostmanRails.config.api_docs_path}/nonexistent.yml").and_return(false)
      
      endpoints = parser.parse_controller('nonexistent')
      
      expect(endpoints).to be_an(Array)
      expect(endpoints).to be_empty
    end
  end
  
  describe '#parse_action' do
    it 'parses a specific action from a controller file' do
      allow(File).to receive(:exist?).with("#{PostmanRails.config.api_docs_path}/users.yml").and_return(true)
      
      endpoint = parser.parse_action('users', 'index')
      
      expect(endpoint).to be_a(Hash)
      expect(endpoint[:controller]).to eq('users')
      expect(endpoint[:action]).to eq('index')
      expect(endpoint[:method]).to eq('GET')
      expect(endpoint[:path]).to eq('/api/v1/users')
      expect(endpoint[:description]).to eq('Retrieve a list of users')
      expect(endpoint[:params]).to be_an(Array)
      expect(endpoint[:responses]).to be_an(Array)
    end
    
    it 'returns nil if the controller file does not exist' do
      allow(File).to receive(:exist?).with("#{PostmanRails.config.api_docs_path}/nonexistent.yml").and_return(false)
      
      endpoint = parser.parse_action('nonexistent', 'index')
      
      expect(endpoint).to be_nil
    end
    
    it 'returns nil if the action does not exist in the controller file' do
      allow(File).to receive(:exist?).with("#{PostmanRails.config.api_docs_path}/users.yml").and_return(true)
      
      endpoint = parser.parse_action('users', 'nonexistent')
      
      expect(endpoint).to be_nil
    end
  end
end 
