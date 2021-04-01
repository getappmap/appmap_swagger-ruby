# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appmap/swagger/version'

Gem::Specification.new do |spec|
  spec.name          = 'appmap_swagger'
  spec.version       = AppMap::Swagger::VERSION
  spec.authors       = ['Kevin Gilpin']
  spec.email         = ['kgilpin@gmail.com']

  spec.summary       = %q{Provides a Rake task to generate Swagger from AppMap data}
  spec.homepage      = 'https://github.com/applandinc/appmap_swagger-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rake'
  spec.add_dependency 'rdoc'
  spec.add_dependency 'reverse_markdown'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'minitest'
end
