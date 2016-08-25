require 'thor'
require 'pretest/structure/clone'

module Pretest

  class StructureGenerator < Thor
    desc "create <NAME>", "This will generate your project structure"
    method_option :web, type: :boolean, desc: "Create a Web Automation Project Structure"
    method_option :ios, type: :boolean, desc: "Create a iOS Mobile Automation Project Structure"
    method_option :android, type: :boolean, desc: "Create a Android Mobile Automation Project Structure"

    def create(name)
      web = options[:web] ? 'true' : 'false'
      ios = options[:ios] ? 'true' : 'false'
      android = options[:android] ? 'true' : 'false'
      Pretest::Structure::Clone.start([name, web, ios, android])
    end

  end

end
