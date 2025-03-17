require 'spec_helper'

RSpec.describe PostmanRails::Config do
  describe 'initialization' do
    it 'sets default values' do
      config = PostmanRails::Config.new
      
      expect(config.api_key).to be_nil
      expect(config.collection_id).to be_nil
      expect(config.api_docs_path).to eq('app/api_docs')
    end
  end
  
  describe 'attribute accessors' do
    it 'allows setting and getting values' do
      config = PostmanRails::Config.new
      
      config.api_key = 'test_api_key'
      config.collection_id = 'test_collection_id'
      config.api_docs_path = 'custom/path'
      
      expect(config.api_key).to eq('test_api_key')
      expect(config.collection_id).to eq('test_collection_id')
      expect(config.api_docs_path).to eq('custom/path')
    end
  end
end

RSpec.describe PostmanRails do
  describe '.configure' do
    it 'yields the config object' do
      PostmanRails.configure do |config|
        config.api_key = 'test_api_key'
        config.collection_id = 'test_collection_id'
        config.api_docs_path = 'custom/path'
      end
      
      expect(PostmanRails.config.api_key).to eq('test_api_key')
      expect(PostmanRails.config.collection_id).to eq('test_collection_id')
      expect(PostmanRails.config.api_docs_path).to eq('custom/path')
    end
  end
  
  describe '.config' do
    it 'returns a Config instance' do
      expect(PostmanRails.config).to be_a(PostmanRails::Config)
    end
    
    it 'returns the same instance on multiple calls' do
      config1 = PostmanRails.config
      config2 = PostmanRails.config
      
      expect(config1).to be(config2)
    end
  end
end 
