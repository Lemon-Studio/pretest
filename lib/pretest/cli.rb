require 'thor'
require 'pretest/structure/clone'
require 'pretest/environment/check'
require 'pretest/mobile/environment'

module Pretest
  class StructureGenerator < Thor
    desc 'create [NAME]', 'This will generate your project structure'
    method_option :web, type: :boolean, desc:
      'Create a Web Automation Project Structure'
    method_option :web_scaffold, type: :boolean, desc:
      'Creates a Web Automation Project Structure with some steps,' \
      ' pages and features already created'
    method_option :api, type: :boolean, desc:
      'Create a API Automation Project Structure'
    method_option :api_scaffold, type: :boolean, desc:
      'Creates a API Automation Project Structure with some steps ' \
      'and features already created'
    method_option :clean_install, type: :boolean, desc:
      'Creates a Clean Web Automation Project Structure'
    method_option :ios, type: :boolean, desc:
      'Create a iOS Mobile Automation Project Structure'
    method_option :android, type: :boolean, desc:
      'Create a Android Mobile Automation Project Structure'

    def create(name)
      web           = options[:web]           ? 'true' : 'false'
      web_scaffold  = options[:web_scaffold]  ? 'true' : 'false'
      api           = options[:api]           ? 'true' : 'false'
      api_scaffold  = options[:api_scaffold]  ? 'true' : 'false'
      clean_install = options[:clean_install] ? 'true' : 'false'
      ios           = options[:ios]           ? 'true' : 'false'
      android       = options[:android]       ? 'true' : 'false'

      Pretest::Structure::Clone.start([name,
                                       web,
                                       web_scaffold,
                                       api,
                                       api_scaffold,
                                       clean_install,
                                       ios,
                                       android])
    end

    desc 'environment', 'Check, configure, and install environment ' \
                        'variables and webdrivers in the current OS'

    def environment
      Pretest::Environment::Check.start
    end

    desc 'mobile_environment [ENVIRONMENT]', 'Check, configure and' \
                                             ' install environment variables and sdk path in the current OS'

    def mobile_environment(env)
      Pretest::Mobile::Environment.start([env])
    end
  end
end
