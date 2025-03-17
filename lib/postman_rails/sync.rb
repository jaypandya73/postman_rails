require "httparty"
require "json"

module PostmanRails
  class Sync
    def initialize
      @parser = Parser.new
      @client = PostmanClient.new
      @collection_id = PostmanRails.config.collection_id
    end

    def sync_all
      endpoints = @parser.parse_all
      update_postman_collection(endpoints)
    end

    def sync_controller(controller)
      endpoints = @parser.parse_controller(controller)
      update_postman_collection(endpoints) unless endpoints.empty?
    end

    def sync_action(controller, action)
      endpoint = @parser.parse_action(controller, action)
      update_postman_endpoint(endpoint) if endpoint
    end

    private

    def update_postman_collection(endpoints)
      collection = convert_to_postman_format(endpoints)
      @client.update_collection(@collection_id, collection["collection"])
    end

    def update_postman_endpoint(endpoint)
      # Get current collection
      collection = @client.get_collection(@collection_id)

      # Find and update the specific endpoint
      update_endpoint_in_collection(collection, endpoint)

      # Update the entire collection
      @client.update_collection(@collection_id, collection)
    end

    def update_endpoint_in_collection(collection, endpoint)
      # This is a simplified implementation
      # In reality, you would need to traverse the collection structure
      # to find and update the specific endpoint

      # For now, we'll just add the endpoint to the collection
      collection["item"] ||= []

      # Check if the endpoint already exists
      existing_index = collection["item"].find_index do |item|
        item["name"] == "#{endpoint[:controller]}##{endpoint[:action]}"
      end

      item = convert_to_postman_item_format(endpoint)

      if existing_index
        collection["item"][existing_index] = item
      else
        collection["item"] << item
      end
    end

    def convert_to_postman_format(endpoints)
      {
        "collection" => {
          "info" => {
            "name" => "API Documentation",
            "schema" => "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
          },
          "item" => endpoints.map { |endpoint| convert_to_postman_item_format(endpoint) }
        }
      }
    end

    def convert_to_postman_item_format(endpoint)
      {
        "name" => "#{endpoint[:controller]}##{endpoint[:action]}",
        "request" => {
          "method" => endpoint[:method],
          "url" => {
            "raw" => endpoint[:path]
          },
          "description" => endpoint[:description],
          "header" => [],
          "body" => {}
        },
        "response" => endpoint[:responses].map do |response|
          {
            "name" => response["description"],
            "code" => response["status"],
            "header" => [
              {
                "key" => "Content-Type",
                "value" => response["content_type"]
              }
            ],
            "body" => response["example"]
          }
        end
      }
    end
  end
end
