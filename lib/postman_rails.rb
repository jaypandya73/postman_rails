# frozen_string_literal: true

require "postman_rails/version"
require "postman_rails/config"
require "postman_rails/postman_client"
require "postman_rails/parser"
require "postman_rails/sync"
require "postman_rails/railtie" if defined?(Rails)

module PostmanRails
  class Error < StandardError; end
  
  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end
  
  # Convenience methods at the module level
  def self.client
    @client ||= PostmanClient.new
  end
  
  def self.list_collections
    client.list_collections
  end
  
  def self.get_collection(collection_id = config.collection_id)
    client.get_collection(collection_id)
  end
  
  def self.create_collection(name, description = nil)
    client.create_collection(name, description)
  end
  
  def self.list_environments
    client.list_environments
  end
  
  def self.get_environment(environment_id)
    client.get_environment(environment_id)
  end
  
  def self.sync_all
    Sync.new.sync_all
  end
  
  def self.sync_controller(controller)
    Sync.new.sync_controller(controller)
  end
  
  def self.sync_action(controller, action)
    Sync.new.sync_action(controller, action)
  end

  # Your code goes here...
end
