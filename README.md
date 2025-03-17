# PostmanRails

PostmanRails is a Ruby gem that allows Rails developers to document their API endpoints using YAML files and automatically sync them with Postman. This gem simplifies the process of keeping your API documentation up-to-date by providing a straightforward way to define your API endpoints and sync them with Postman.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'postman_rails'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install postman_rails
```

## Configuration

Create an initializer file in your Rails application:

```ruby
# config/initializers/postman_rails.rb
PostmanRails.configure do |config|
  config.api_key = ENV['POSTMAN_API_KEY']
  config.collection_id = ENV['POSTMAN_COLLECTION_ID']
  config.api_docs_path = "app/api_docs" # Default path
end
```

## Usage

### Defining API Endpoints

Create YAML files in the `app/api_docs` directory (or the directory you specified in the configuration). Each file should correspond to a controller and define its actions.

Example:

```yaml
# app/api_docs/users.yml
controller: users
actions:
  index:
    method: GET
    path: /api/v1/users
    description: Retrieve a list of users
    params:
      - name: page
        type: integer
        description: Page number
        required: false
      - name: per_page
        type: integer
        description: Items per page
        required: false
        default: 10
    responses:
      - status: 200
        content_type: application/json
        description: List of users
        example: |
          {
            "users": [
              {
                "id": 1,
                "name": "John Doe",
                "email": "john@example.com"
              }
            ]
          }
      - status: 400
        content_type: application/json
        description: Bad request
  
  show:
    method: GET
    path: /api/v1/users/:id
    description: Retrieve a user by ID
    params:
      - name: id
        type: integer
        description: User ID
        required: true
    responses:
      - status: 200
        content_type: application/json
        description: User details
      - status: 404
        content_type: application/json
        description: User not found
```

### Syncing with Postman

#### Using Rake Tasks

To sync all API endpoints with Postman:

```bash
$ rake postman:sync_all
```

To sync a specific controller:

```bash
$ rake postman:sync_controller[users]
```

To sync a specific action:

```bash
$ rake postman:sync_action[users,index]
```

#### Managing Postman Collections

List all your Postman collections:

```bash
$ rake postman:list_collections
```

Show details of a specific collection:

```bash
$ rake postman:show_collection[collection_id]
```

Create a new Postman collection:

```bash
$ rake postman:create_collection[name,description]
```

List all your Postman environments:

```bash
$ rake postman:list_environments
```

### Using PostmanRails Programmatically

In addition to the Rake tasks, you can use PostmanRails programmatically in your application:

#### Accessing Postman Collections

```ruby
# List all collections
collections = PostmanRails.list_collections

# Get a specific collection
collection = PostmanRails.get_collection('collection_id')

# Create a new collection
collection = PostmanRails.create_collection('My New Collection', 'Description')
```

#### Syncing API Documentation

```ruby
# Sync all endpoints
PostmanRails.sync_all

# Sync a specific controller
PostmanRails.sync_controller('users')

# Sync a specific action
PostmanRails.sync_action('users', 'index')
```

#### Using the PostmanClient Directly

For more advanced usage, you can use the PostmanClient class directly:

```ruby
client = PostmanRails::PostmanClient.new(api_key)

# Work with collections
collections = client.list_collections
collection = client.get_collection(collection_id)
client.update_collection(collection_id, collection_data)

# Work with environments
environments = client.list_environments
environment = client.get_environment(environment_id)
```

## Development Environment

This gem is primarily intended for use in development environments. We recommend adding it to your development group in your Gemfile:

```ruby
group :development do
  gem 'postman_rails'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jayved128/postman_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jayved128/postman_rails/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PostmanRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jayved128/postman_rails/blob/main/CODE_OF_CONDUCT.md).
