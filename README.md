# `appmap_swagger`

This gem provides a Rake task called `swagger` that generates [Swagger 3](https://swagger.io/specification/) (aka OpenAPI) YAML from [AppMap](https://github.com/applandinc/appmap-ruby) data.

It depends on an NPM package called [@appland/appmap-swagger](https://www.npmjs.com/package/@appland/appmap-swagger), which does most of the heavy lifting of converting AppMaps to Swagger.

To the NPM package, this gem adds:

* A Rake task - Normally configured as `appmap:swagger`.
* Rails integration - For example, default configuration of the application name.
* Swagger "diff" - Smart comparison of the current revision Swagger YAML to a base revision.

# Quick start video

Check out [Generate Swagger for your Rails project, with no code changes, in 2 ¹/₂ minutes](https://dev.to/appland/generate-swagger-for-your-rails-project-with-no-code-changes-in-2-minutes-3abj)

[![Introducing appmap_swagger](https://user-images.githubusercontent.com/86395/114316594-3f418400-9ad2-11eb-9449-683fd6d34963.png)](https://dev.to/appland/generate-swagger-for-your-rails-project-with-no-code-changes-in-2-minutes-3abj)


# How it works

The Rake task `swagger`:

1. Requires Node.js, and it requires the `@appland/appmap-swagger` package to be installed from NPM.
2. Runs the Node.js program `appmap-swagger` to generate Swagger YAML.
3. Merges the generated Swagger with a template file.
4. Applies some sensible defaults for Ruby, and Ruby on Rails.
5. Outputs two files to the specified directory (default: `swagger`):
     1. `openapi.yaml` Full Swagger, including documentation and examples.
     2. `openapi_stable.yaml` Swagger without documentation and examples, so that it's more stable across versions.

`openapi_stable.yaml` is ideal for use in code reviews, to see if (and how) web services have been changed.

The Rake task `swagger:diff`:

1. Computes a smart "diff" between the current revision Swagger and base revision.
2. Prints this diff in a user-friendly format, suitable for inclusion in a pull request or issue comment.

## Installation

1. Install Node.js.

2. Install the `@appland/appmap-swagger` package from NPM.

3. Install the `appmap_swagger` Gem.

Add this line to your application's Gemfile:

```ruby
group :development, :test do
  gem 'appmap_swagger'
end
```

And then execute:

    $ bundle install

4. Define the Rake tasks `appmap:swagger` and `appmap:swagger:diff`.

You need to define the Rake tasks, which by default are named `swagger` and `swagger:diff`. They are normally placed
in a namespace `appmap`, to make full task names `appmap:swagger` and `appmap:swagger:diff`.

To add the Rake tasks to a Rails app, add `lib/tasks/appmap.rake`.

In the file, check the Rails environment, and then configure the Rake tasks. You'll probably want to provide
a project name and version. (The default project name is determined from your Rails Application class name and might work fine).

```ruby
namespace :appmap do
  if %w[test development].member?(Rails.env)
    # In a Rails app, add a dependency on the :environment task.
    AppMap::Swagger::RakeTask.new(:swagger, [] => [ :environment ]).tap do |task|
      task.project_name = 'My Server API'
      # You may not have a VERSION file. Do what works best for you.
      task.project_version = "v#{File.read(File.join(Rails.root, 'VERSION')).strip}"
    end

    AppMap::Swagger::RakeDiffTask.new(:'swagger:diff', [ :base, :swagger_file ]).tap do |task|
      # Default base; can be overridden by the :base task argument
      task.base = 'remotes/origin/main'
      # Default swagger file; can be overridden by the :swagger_file task argument
      task.swagger_file = 'swagger/openapi_stable.yaml'
    end
  end
end
```

## Usage example

```sh-session
$ ./bin/rake appmap:swagger:diff
changed       @ info.version
old value     : v0.22.0
new value     : v0.22.1

added         @ paths."/api/api_keys".delete.responses
added key     : 200
added value   : {"content"=>{"application/json"=>{}}}

removed       @ paths."/scenarios/{id}".put.requestBody.content."application/json".schema.properties.scenario.properties
removed key   : mapset
removed value : {"type"=>"string"}

removed       @ paths."/scenarios/{scenario_id}/save_as".post.requestBody.content."application/json".schema.properties.save_as.properties
removed key   : feature
removed value : {"type"=>"string"}

removed       @ paths."/scenarios/{scenario_id}/save_as".post.requestBody.content."application/json".schema.properties.save_as.properties
removed key   : feature_group
removed value : {"type"=>"string"}
```

## Incorporating the Swagger API and UI

Two other gems work great with `appmap:swagger`: `rswag-api` and `rswag-ui` from [rswag](https://github.com/rswag/rswag).

Install in your Gemfile:

```ruby
# By default, let's not run this in production until we've thought about the implications.
group :test, :development do
  gem 'rswag-api'
  gem 'rswag-ui'
end
```

Then run the install commands:

```sh-session
$ rails g rswag:api:install
$ rails g rswag:ui:install
```

Update `routes.rb`:

```ruby
  if defined?(Rswag)
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake gem:release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/applandinc/appmap_swagger-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
