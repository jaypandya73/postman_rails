require 'rails'

module PostmanRails
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/postman_rails.rake"
    end
  end
end 
