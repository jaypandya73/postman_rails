require "spec_helper"

RSpec.describe PostmanRails::Sync do
  let(:collection_id) { "12345678-1234-1234-1234-123456789012" }
  let(:api_key) { "test_api_key" }
  let(:client) { instance_double(PostmanRails::PostmanClient) }
  let(:parser) { instance_double(PostmanRails::Parser) }
  let(:sync) { PostmanRails::Sync.new }

  before do
    PostmanRails.configure do |config|
      config.api_key = api_key
      config.collection_id = collection_id
      config.api_docs_path = "spec/fixtures"
    end

    allow(PostmanRails::PostmanClient).to receive(:new).and_return(client)
    allow(PostmanRails::Parser).to receive(:new).and_return(parser)

    allow(sync).to receive(:puts) # Suppress output during tests
  end

  describe "#sync_all" do
    let(:endpoints) do
      [
        {
          controller: "users",
          action: "index",
          method: "GET",
          path: "/api/v1/users",
          description: "Retrieve a list of users",
          params: [],
          responses: []
        }
      ]
    end

    it "syncs all endpoints" do
      allow(parser).to receive(:parse_all).and_return(endpoints)
      expect(client).to receive(:update_collection).with(collection_id, anything)

      sync.sync_all
    end
  end

  describe "#sync_controller" do
    let(:controller) { "users" }
    let(:endpoints) do
      [
        {
          controller: controller,
          action: "index",
          method: "GET",
          path: "/api/v1/users",
          description: "Retrieve a list of users",
          params: [],
          responses: []
        }
      ]
    end

    it "syncs a specific controller" do
      allow(parser).to receive(:parse_controller).with(controller).and_return(endpoints)
      expect(client).to receive(:update_collection).with(collection_id, anything)

      sync.sync_controller(controller)
    end

    it "does nothing if the controller has no endpoints" do
      allow(parser).to receive(:parse_controller).with(controller).and_return([])
      expect(client).not_to receive(:update_collection)

      sync.sync_controller(controller)
    end
  end

  describe "#sync_action" do
    let(:controller) { "users" }
    let(:action) { "index" }
    let(:endpoint) do
      {
        controller: controller,
        action: action,
        method: "GET",
        path: "/api/v1/users",
        description: "Retrieve a list of users",
        params: [],
        responses: []
      }
    end
    let(:collection) do
      {
        "info" => {
          "name" => "Test Collection",
          "schema" => "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        "item" => []
      }
    end

    it "syncs a specific action" do
      allow(parser).to receive(:parse_action).with(controller, action).and_return(endpoint)
      allow(client).to receive(:get_collection).with(collection_id).and_return(collection)
      expect(client).to receive(:update_collection).with(collection_id, anything)

      sync.sync_action(controller, action)
    end

    it "does nothing if the action does not exist" do
      allow(parser).to receive(:parse_action).with(controller, action).and_return(nil)
      expect(client).not_to receive(:get_collection)
      expect(client).not_to receive(:update_collection)

      sync.sync_action(controller, action)
    end
  end

  describe "#update_endpoint_in_collection" do
    let(:endpoint) do
      {
        controller: "users",
        action: "index",
        method: "GET",
        path: "/api/v1/users",
        description: "Retrieve a list of users",
        params: [],
        responses: []
      }
    end
    let(:collection) do
      {
        "item" => []
      }
    end

    it "adds a new endpoint to the collection" do
      sync.send(:update_endpoint_in_collection, collection, endpoint)

      expect(collection["item"].size).to eq(1)
      expect(collection["item"].first["name"]).to eq("users#index")
    end

    it "updates an existing endpoint in the collection" do
      # Add an endpoint to the collection
      collection["item"] << {
        "name" => "users#index",
        "request" => {
          "method" => "POST", # Different method to test update
          "url" => {
            "raw" => "/api/v1/users"
          }
        }
      }

      sync.send(:update_endpoint_in_collection, collection, endpoint)

      expect(collection["item"].size).to eq(1)
      expect(collection["item"].first["name"]).to eq("users#index")
      expect(collection["item"].first["request"]["method"]).to eq("GET")
    end
  end
end
