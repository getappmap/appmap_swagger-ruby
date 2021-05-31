# About

`appmap_swagger` is a Ruby gem which provides a Rake task to generate [Swagger 3](https://swagger.io/specification/) (aka OpenAPI) YAML from [AppMap](https://github.com/applandinc/appmap-ruby) data.

It depends on an NPM package called [@appland/appmap-swagger](https://www.npmjs.com/package/@appland/appmap-swagger), which does most of the heavy lifting of converting AppMaps to Swagger.

To the NPM package, this gem adds:

* A Rake task - Normally configured as `appmap:swagger`.
* Rails integration - For example, default configuration of the application name.
* Swagger "diff" - Smart comparison of the current revision Swagger YAML to a base revision.

# Usage

Visit the [AppMap Swagger for Ruby](https://appland.com/docs/reference/appmap-swagger-ruby.html) reference page on AppLand.com for a complete reference guide.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake gem:release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/applandinc/appmap_swagger-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
