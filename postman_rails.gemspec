# frozen_string_literal: true

require_relative "lib/postman_rails/version"

Gem::Specification.new do |spec|
  spec.name = "postman_rails"
  spec.version = PostmanRails::VERSION
  spec.authors = ["jay"]
  spec.email = ["jayved128@gmail.com"]

  spec.summary = "A Ruby gem to sync Rails API endpoints with Postman"
  spec.description = "PostmanRails allows Rails developers to document their API endpoints using YAML files and automatically sync them with Postman."
  spec.homepage = "https://github.com/jayved128/postman_rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jayved128/postman_rails"
  spec.metadata["changelog_uri"] = "https://github.com/jayved128/postman_rails/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "activesupport", ">= 6.0.0"
  spec.add_dependency "httparty", "~> 0.21.0"
  spec.add_dependency "railties", ">= 6.0.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.18"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
