require 'thor/group'

module Pretest
  module Structure
    class Clone < Thor::Group
      include Thor::Actions

      argument :name, type: :string, desc:
        'Project Name'
      argument :web, type: :string, desc:
        'Set Project Structure to Web Automation'
      argument :web_scaffold, type: :string, desc:
        'Set Project Structure to Web Automation and Creates some examples'
      argument :api, type: :string, desc:
        'Set Project Structure to API Automation'
      argument :api_scaffold, type: :string, desc:
        'Set Project Structure to API Automation and Creates some examples'
      argument :clean_install, type: :string, desc:
        'Set a Clean Project Structure to Web Automation'
      argument :ios, type: :string, desc:
        'Set Project Structure to iOS Mobile Automation'
      argument :android, type: :string, desc:
        'Set Project Structure to Android Mobile Automation'

      desc 'Creates a new project for tests with Cucumber'

      def self.source_root
        File.dirname(__FILE__) + '/clone'
      end

      def structure_init
        Dir.mkdir(name) unless File.exist?(name)
        Dir.chdir(name)
        dir_list
      end

      def cucumber_yml_clone
        template 'cucumber.yml.tt',
                 "#{name}/cucumber.yml"
      end

      def gemfile_clone
        template 'Gemfile.tt',
                 "#{name}/Gemfile"
      end

      def hooks_clone
        template 'hooks.rb.tt',
                 "#{name}/features/support/hooks.rb"
      end

      def env_clone
        template 'env.rb.tt',
                 "#{name}/features/support/env.rb"
      end

      def step_definitions_clone
        template 'step_definitions.rb.tt',
                 "#{name}/features/step_definitions/step_definitions.rb"
      end

      def feature_clone
        template 'example.feature.tt',
                 "#{name}/features/example.feature"
      end

      def app_life_cycle_hooks_clone
        if android == 'true'
          template 'app_life_cycle_hooks.rb.tt',
                   "#{name}/features/support/app_life_cycle_hooks.rb"
        end
      end

      def app_installation_hook_clone
        if android == 'true'
          template 'app_installation_hook.rb.tt',
                   "#{name}/features/support/app_installation_hook.rb"
        end
      end

      def dry_run_clone
        if ios == 'true'
          template 'dry_run.rb.tt',
                   "#{name}/features/support/dry_run.rb"
        end
      end

      def first_launch_clone
        if ios == 'true'
          template 'first_launch.rb.tt',
                   "#{name}/features/support/first_launch.rb"
        end
      end

      def page_clone
        template 'example.rb.tt',
                 "#{name}/features/support/pages/example.rb"
      end

      no_commands do
        def create_dir(dir)
          Dir.mkdir(dir) unless File.exist?(dir)
        end

        def dir_list
          create_dir('data')
          create_dir('features')
          create_dir('features/support')
          create_dir('features/step_definitions')
          create_dir('features/support/pages')
        end
      end
    end
  end
end
