require 'spec_helper'
require 'open3'

describe Pretest do
  before(:each) do
    @current_dir = Dir.pwd
    @dir = Dir.mktmpdir('pretest')
    Dir.chdir(@dir)
  end

  content = -> (file) { File.read(file).strip }

  after(:each) do
    FileUtils.rm_rf(@dir)
    Dir.chdir(@current_dir)
  end

  it 'creates a new empty project and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder}"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"

    expect(content.(feature_file)).to   be_empty
    expect(content.(steps_content)).to  be_empty
    expect(content.(env_content)).to    be_empty
    expect(content.(hooks_content)).to  be_empty
    expect(content.(pages_content)).to  be_empty

    expect('cucumber.yml').not_to       be_empty
    expect('Gemfile').not_to            be_empty
  end

  it 'creates a new project with --web_scaffold flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --web_scaffold"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"

    feature_data = ["Background", "Given I am on", "Feature"]
    steps_data   = ["# Visit web page", "# Click on item"]
    env_data     = ["if ENV['chrome']", "require 'capybara/cucumber'"]
    hooks_data   = ["require 'selenium-webdriver'"]
    pages_data   = ["class Example", "include Capybara::DSL"]

    expect(content.(feature_file)).to   include(*feature_data)
    expect(content.(steps_content)).to  include(*steps_data)
    expect(content.(env_content)).to    include(*env_data)
    expect(content.(hooks_content)).to  include(*hooks_data)
    expect(content.(pages_content)).to  include(*pages_data)

    expect('cucumber.yml').not_to       be_empty
    expect('Gemfile').not_to            be_empty
  end

  it 'create a new project with --api flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --api"

  end

  it 'create a new project with --api_scaffold flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --api_scaffold"

  end

  it 'create a new project with --ios flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --ios"

  end

  it 'create a new project with --android flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --android"

  end

end
