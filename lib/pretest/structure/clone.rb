require 'thor/group'

module Pretest

  module Structure

    class Clone < Thor::Group

      include Thor::Actions

      argument :name, type: :string, desc: "Project Name"
      argument :web, type: :string, desc: "Set Project Structure to Web Automation"
      argument :ios, type: :string, desc: "Set Project Structure to iOS Mobile Automation"
      argument :android, type: :string, desc: "Set Project Structure to Android Mobile Automation"
      argument :web_scaffold, type: :string, desc: "Set Project Structure to Web Automation and Creates some examples"
      argument :clean_install, type: :string, desc: "Set a Clean Project Structure to Web Automation"
      argument :no_bundle, type: :string, desc: "Set bundle install config to turned off"

      desc "Creates a new project for tests with Cucumber"

      def self.source_root
        File.dirname(__FILE__) + "/clone"
      end

      def structure_init
        Dir.mkdir(name) unless File.exist?(name)
        Dir.chdir(name)
        dir_list
      end

      def cucumber_yml_clone
        template "cucumber.yml.tt", "#{name}/cucumber.yml"
      end

      def gemfile_clone
        template "Gemfile.tt", "#{name}/Gemfile"
      end

      def hooks_clone
        template "hooks.rb.tt", "#{name}/features/support/hooks.rb"
      end

      def env_clone
        template "env.rb.tt", "#{name}/features/support/env.rb"
      end

      def step_definitions_clone
        template "step_definitions.rb.tt", "#{name}/features/step_definitions/step_definitions.rb"
      end

      def feature_clone
        template "example.feature.tt", "#{name}/features/example.feature"
      end

      def page_clone
        template "example.rb.tt", "#{name}/features/support/pages/example.rb"
      end

      def bundle_install
        system "bundle install --gemfile=Gemfile" unless clean_install == 'true' or no_bundle == 'true'
      end

      no_commands do


        def create_dir(dir)
          Dir.mkdir(dir) unless File.exist?(dir)
        end

        def dir_list
          create_dir("data")
          create_dir("features")
          create_dir("features/support")
          create_dir("features/step_definitions")
          create_dir("features/support/pages")
        end

      end

    end

  end

end
