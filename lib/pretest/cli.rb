require 'thor'
require 'pretest/structure/clone'
require 'pretest/environment/check'

module Pretest

  class StructureGenerator < Thor
    desc "create <NAME>", "This will generate your project structure"
    method_option :web, type: :boolean, desc: "Create a Web Automation Project Structure"
    method_option :ios, type: :boolean, desc: "Create a iOS Mobile Automation Project Structure"
    method_option :android, type: :boolean, desc: "Create a Android Mobile Automation Project Structure"
    method_option :web_scaffold, type: :boolean, desc: "Creates a Web Automation Project Structure with some steps, pages and features already created"

    def create(name)
      web = options[:web] ? 'true' : 'false'
      ios = options[:ios] ? 'true' : 'false'
      android = options[:android] ? 'true' : 'false'
      web_scaffold = options[:web_scaffold] ? 'true' : 'false'
      Pretest::Structure::Clone.start([name, web, ios, android, web_scaffold])
    end

    desc "environment <OPTION>", "There is three options that we can use: set_env, check_env and show_env"
    #method_option :set_env, type: :boolean, desc: "Set environment variables with the actual OS"
    #method_option :check_env, type: :boolean, desc: "Check environment variables in actual OS"
    #method_option :show_env, type: :boolean, desc: "Show environment variables from actual OS"

    def environment
      #set_env = options[:set_env]
      #check_env = options[:check_env]
      #show_env = options[:show_env]
      Pretest::Environment::Check.start
    end

  end

end
