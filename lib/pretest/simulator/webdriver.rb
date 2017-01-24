#require 'thor/group'
#require 'capybara/dsl'
#require 'pry'
#require 'capybara/poltergeist'

module Pretest
  module WebDriver
    class Simulate < Thor::Group
      include Thor::Actions
      #include Capybara::DSL

      desc 'Simulate capybara actions with the defined webdriver'

      argument :webdriver, type: :string, desc: 'WebDriver to Simulate'

      def webdriver_simulate
        url = 'https://www.google.com'
        case webdriver
        when 'chrome'
          Capybara.register_driver :chrome do |app|
            Capybara::Selenium::Driver.new(app, browser: :chrome)
          end
          Capybara.javascript_driver = :chrome
          Capybara.default_driver = :chrome
          visit(url)
        when 'firefox'
          Capybara.default_driver = :selenium
          visit(url)
        when 'phantomjs'
          Capybara.javascript_driver = :poltergeist
          Capybara.default_driver = :poltergeist
          visit(url)
        end
        binding.pry
      end
    end
  end
end
