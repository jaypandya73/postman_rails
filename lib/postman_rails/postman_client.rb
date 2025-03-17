require 'httparty'
require 'json'

module PostmanRails
  class PostmanClient
    def initialize(api_key = nil)
      @api_key = api_key || PostmanRails.config.api_key
    end
    
    # Collection methods
    def list_collections
      get_request("collections")['collections'] || []
    end
    
    def get_collection(collection_id)
      get_request("collections/#{collection_id}")['collection']
    end
    
    def create_collection(name, description = nil)
      body = {
        collection: {
          info: {
            name: name,
            description: description,
            schema: "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
          },
          item: []
        }
      }
      
      post_request("collections", body)['collection']
    end
    
    def update_collection(collection_id, collection_data)
      put_request("collections/#{collection_id}", { collection: collection_data })
    end
    
    # Environment methods
    def list_environments
      get_request("environments")['environments'] || []
    end
    
    def get_environment(environment_id)
      get_request("environments/#{environment_id}")['environment']
    end
    
    # Helper methods for HTTP requests
    private
    
    def get_request(path)
      response = HTTParty.get(
        "https://api.getpostman.com/#{path}",
        headers: { 'X-Api-Key' => @api_key }
      )
      
      handle_response(response)
    end
    
    def post_request(path, body)
      response = HTTParty.post(
        "https://api.getpostman.com/#{path}",
        headers: { 
          'X-Api-Key' => @api_key,
          'Content-Type' => 'application/json'
        },
        body: body.to_json
      )
      
      handle_response(response)
    end
    
    def put_request(path, body)
      response = HTTParty.put(
        "https://api.getpostman.com/#{path}",
        headers: { 
          'X-Api-Key' => @api_key,
          'Content-Type' => 'application/json'
        },
        body: body.to_json
      )
      
      handle_response(response)
    end
    
    def handle_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        raise Error, "Postman API error: #{response.code} - #{response.body}"
      end
    end
  end
end 
