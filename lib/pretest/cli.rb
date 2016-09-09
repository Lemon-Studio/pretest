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

    desc "environment <OPTION>", "Check, configure, and install environment variables and webdrivers in the current OS"

    def environment
      Pretest::Environment::Check.start
    end

  end

end
