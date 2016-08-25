require 'rspec'
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
elsif ENV['ie']
  Capybara.default_driver = :ie
  Capybara.register_driver :ie do |app|
    Capybara::Selenium::Driver.new(app, browser: :internet_explorer)
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
end
