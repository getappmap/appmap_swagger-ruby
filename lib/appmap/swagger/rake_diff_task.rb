# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'hashdiff'

module AppMap
  module Swagger
    class RakeDiffTask < ::Rake::TaskLib
      DEFAULT_BASE         = 'remotes/origin/main'
      DEFAULT_GIT          = 'git'
      DEFAULT_SWAGGER_FILE = 'swagger/openapi_stable.yaml'

      attr_accessor :name, :git_command, :base, :swagger_file

      Command = Struct.new(:git_command, :base, :swagger_file) do
        def verbose
          Rake.verbose == true
        end
  
        def perform
          do_fail = lambda do |msg|
            warn msg
            exit $?.exitstatus || 1
          end
  
          return do_fail.(%Q('#{git_command}' not found; please install git)) unless system('git --version 2>&1 > /dev/null')

          fetch_command = 'git fetch'
          warn fetch_command if verbose
          do_fail.(%Q(#{fetch_command} failed)) unless system(fetch_command)

          show_command = %Q(git show #{base}:#{swagger_file})
          warn show_command if verbose
          base_content = `#{show_command}`
          do_fail.(%Q(#{show_command} failed)) unless $?.exitstatus == 0

          base_content = YAML.load(base_content)
          head_content = YAML.load(File.read(swagger_file))

          format_path = lambda do |tokens|
            tokens.map do |token|
              if token =~ /^[a-zA-Z0-9_-]+$/
                token
              else
                %Q("#{token}")
              end
            end.join('.')
          end

          format_change = lambda do |entry|
            path, old_v, new_v = entry
            [
              "changed       @ #{format_path.call path.split('.')}",
              "old value     : #{old_v}",
              "new value     : #{new_v}" 
            ].join("\n")
          end

          format_deletion = lambda do |entry|
            path, old_v = entry
            path_tokens = path.split('.')
            removed_key = path_tokens.pop
            [
              "removed       @ #{format_path.call path_tokens}",
              "removed key   : #{removed_key}",
              "removed value : #{old_v}" 
            ].join("\n")
          end

          format_addition = lambda do |entry|
            path, new_v = entry
            path_tokens = path.split('.')
            added_key = path_tokens.pop
            [
              "added         @ #{format_path.call path_tokens}",
              "added key     : #{added_key}",
              "added value   : #{new_v}" 
            ].join("\n")
          end

          formatters = {
            '~' => format_change,
            '-' => format_deletion,
            '+' => format_addition,
          }

          diff = Hashdiff.diff(base_content, head_content)
          diff.each_with_index do |entry, index|
            puts unless index == 0
            warn YAML.dump(entry) if verbose
            puts formatters[entry[0]].(entry[1..-1])
          end
        end
      end

      def initialize(*args, &task_block)
        @name         = args.shift || :'swagger:diff'
        @git_command  = DEFAULT_GIT
        @base         = DEFAULT_BASE
        @swagger_file = DEFAULT_SWAGGER_FILE

        define(args, &task_block)
      end

      private

      # This bit of black magic - https://github.com/rspec/rspec-core/blob/main/lib/rspec/core/rake_task.rb#L110
      def define(args, &task_block)
        desc "Generate Swagger from AppMaps" unless ::Rake.application.last_description

        task(name, *args) do |_, task_args|
          RakeFileUtils.__send__(:verbose, Rake.verbose == true) do
            task_block.call(*[self, task_args].slice(0, task_block.arity)) if task_block
            Command.new(:git_command).tap do |cmd|
              cmd.base = task_args[:base] || self.base
              cmd.swagger_file = task_args[:swagger_file] || self.swagger_file
            end.perform
          end
        end
      end
    end
  end
end
