require 'yaml'

module PostmanRails
  class Parser
    def parse_all
      endpoints = []
      
      Dir.glob("#{PostmanRails.config.api_docs_path}/*.yml").each do |file|
        endpoints.concat(parse_file(file))
      end
      
      endpoints
    end
    
    def parse_controller(controller)
      file_path = "#{PostmanRails.config.api_docs_path}/#{controller}.yml"
      return [] unless File.exist?(file_path)
      
      parse_file(file_path)
    end
    
    def parse_action(controller, action)
      file_path = "#{PostmanRails.config.api_docs_path}/#{controller}.yml"
      return nil unless File.exist?(file_path)
      
      endpoints = parse_file(file_path)
      endpoints.find { |endpoint| endpoint[:action] == action }
    end
    
    private
    
    def parse_file(file_path)
      data = YAML.load_file(file_path)
      controller = data['controller']
      
      endpoints = []
      
      data['actions'].each do |action_name, action_data|
        endpoints << {
          controller: controller,
          action: action_name,
          method: action_data['method'],
          path: action_data['path'],
          description: action_data['description'],
          params: action_data['params'],
          responses: action_data['responses']
        }
      end
      
      endpoints
    end
  end
end 
