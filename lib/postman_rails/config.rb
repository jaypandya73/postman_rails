module PostmanRails
  class Config
    attr_accessor :api_key, :collection_id, :api_docs_path
    
    def initialize
      @api_key = nil
      @collection_id = nil
      @api_docs_path = "app/api_docs"
    end
  end
end 
