require 'thor'
require 'pretest/structure/clone'
require 'pretest/environment/check'
#require 'pretest/simulator/webdriver'

module Pretest
  class StructureGenerator < Thor
    desc 'create [NAME]', 'This will generate your project structure'
    method_option :web, type: :boolean, desc: 'Create a Web Automation Project Structure'
    method_option :ios, type: :boolean, desc: 'Create a iOS Mobile Automation Project Structure'
    method_option :android, type: :boolean, desc: 'Create a Android Mobile Automation Project Structure'
    method_option :web_scaffold, type: :boolean, desc: 'Creates a Web Automation Project Structure with some steps, pages and features already created'
    method_option :clean_install, type: :boolean, desc: 'Creates a Clean Web Automation Project Structure'
    method_option :no_bundle, type: :boolean, desc: 'Sets bundle install to turned off'

    def create(name)
      web = options[:web] ? 'true' : 'false'
      ios = options[:ios] ? 'true' : 'false'
      android = options[:android] ? 'true' : 'false'
      web_scaffold = options[:web_scaffold] ? 'true' : 'false'
      clean_install = options[:clean_install] ? 'true' : 'false'
      no_bundle = options[:no_bundle] ? 'true' : 'false'
      Pretest::Structure::Clone.start([name, web, ios, android, web_scaffold, clean_install, no_bundle])
    end

    desc 'environment', 'Check, configure, and install environment variables and webdrivers in the current OS'

    def environment
      Pretest::Environment::Check.start
    end

    desc 'start_webdriver', 'Simulate Capybara/Selenium interactions with the defined WebDriver'

    def start_webdriver(webdriver)
      Pretest::WebDriver::Simulate.start([webdriver])
    end
  end
end
