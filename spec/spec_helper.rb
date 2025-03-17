# frozen_string_literal: true

require "bundler/setup"
require "postman_rails"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  # Clear configuration between tests
  config.before(:each) do
    PostmanRails.instance_variable_set(:@config, nil)
    PostmanRails.instance_variable_set(:@client, nil)
  end
end

# Helper method to load fixture files
def fixture_path(filename)
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end

def fixture(filename)
  File.read(fixture_path(filename))
end

def json_fixture(filename)
  JSON.parse(fixture(filename))
end
