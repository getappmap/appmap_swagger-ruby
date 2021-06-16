require "bundler/gem_tasks"
require "rake/testtask"

module Bundler
  class GemHelper
    alias default_build_gem build_gem

    # A handy type - find the location of any Rake task using `rake -W`.
    # rake -W build
    # ~/.rbenv/versions/2.6.6/lib/ruby/gems/2.6.0/gems/bundler-2.1.4/lib/bundler/gem_helper.rb:39:in `install'
    def build_gem
      # Ensure that NPM packages are installed before building.
      sh('yarn install'.shellsplit)

      default_build_gem
    end
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test
