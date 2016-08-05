require "pretest/version"
require 'thor'

module Pretest
  class StructureGenerator < Thor
    desc "project NAME", "This will generate your project structure"
    long_desc <<-PRETEST

    `project NAME` will generate a cucumber project structure with the NAME given.

    PRETEST
    option :upcase
    def project( name )
      Dir.mkdir(name) unless File.exist?(name)
      Dir.chdir(name)
      dir_list
      file_list
      list_project
    end

    if ARGV.count == 1 and ARGV != "help"
      puts "O comando para criação de projetos foi alterado de:
'pretest nome_do_projeto' para 'pretest project nome_do_projeto'."
    end

    no_commands do

      def list_project
        puts "Project Created:

Gemfile
cucumber.yml
data
features
features/step_definitions
features/support
features/support/env.rb
feature/support/hooks.rb
feature/support/pages"
      end

      def file_list
        create_file("Gemfile", "source 'https://rubygems.org'
gem 'chromedriver-helper'
gem 'pry'
gem 'faker'
gem 'capybara'
gem 'cucumber'
gem 'rspec'
gem 'rake'
gem 'selenium-webdriver'
gem 'page-object'")
        create_file("cucumber.yml", "default: --no-source --color --format pretty")
        create_file("features/step_definitions/step_definitions.rb", "")
        create_file("features/support/env.rb", "require 'rspec'
require 'page-object'
require 'faker'
require 'capybara/cucumber'
require 'pry'
require 'capybara/poltergeist'

if ENV['chrome']
  Capybara.default_driver = :chrome
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
elsif ENV['firefox']
  Capybara.default_driver = :firefox
  Capybara.register_driver :firefox do |app|
    Capybara::Selenium::Driver.new(app, browser: :firefox)
  end
elsif ENV['headless_debug']
  Capybara.default_driver = :poltergeist_debug
  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new(app, inspector: true)
  end
  Capybara.javascript_driver = :poltergeist_debug
elsif ENV['headless']
  Capybara.javascript_driver = :poltergeist
  Capybara.default_driver = :poltergeist
else
  Capybara.default_driver = :selenium
end")
        create_file("features/support/hooks.rb", "require 'selenium-webdriver'")
      end

      def create_dir(dir)
        Dir.mkdir(dir) unless File.exist?(dir)
      end

      def create_file(name, text)
        File.open(name, "w") {|x| x.write(text)}
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
