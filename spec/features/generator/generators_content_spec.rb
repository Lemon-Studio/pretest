require 'spec_helper'

describe 'Pretest Content Checker' do
  before(:each) do
    @current_dir = Dir.pwd
    @dir = Dir.mktmpdir('pretest')
    Dir.chdir(@dir)
  end

  content = ->(file) { File.read(file).strip }

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
    gemfile_content = "#{folder}/Gemfile"
    cukes_content   = "#{folder}/cucumber.yml"

    expect(content.(feature_file)).to         be_empty
    expect(content.(steps_content)).to        be_empty
    expect(content.(pages_content)).to        be_empty

    expect(content.(hooks_content)).not_to        be_empty
    expect(content.(env_content)).not_to          be_empty
    expect(content.(cukes_content)).not_to        be_empty
    expect(content.(gemfile_content)).not_to      be_empty
  end

  it 'creates a new project with --web_scaffold flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --web_scaffold"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"
    cukes_content   = "#{folder}/cucumber.yml"
    gemfile_content = "#{folder}/Gemfile"

    feature_data = ['Background', 'Given I am on', 'Feature']
    steps_data   = ['# Visit web page', '# Click on item']
    env_data     = ["if ENV['chrome']", "require 'capybara/cucumber'"]
    hooks_data   = ["require 'selenium-webdriver'", 'Before do']
    pages_data   = ['class Example', 'include Capybara::DSL']

    expect(content.(feature_file)).to   include(*feature_data)
    expect(content.(steps_content)).to  include(*steps_data)
    expect(content.(env_content)).to    include(*env_data)
    expect(content.(hooks_content)).to  include(*hooks_data)
    expect(content.(pages_content)).to  include(*pages_data)

    expect(content.(cukes_content)).not_to      be_empty
    expect(content.(gemfile_content)).not_to    be_empty
  end

  it 'create a new project with --api flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --api"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"
    gemfile_content = "#{folder}/Gemfile"
    cukes_content   = "#{folder}/cucumber.yml"

    gemfile_data    = "gem 'rest-client'"

    expect(content.(feature_file)).to         be_empty
    expect(content.(steps_content)).to        be_empty
    expect(content.(hooks_content)).to        be_empty
    expect(content.(pages_content)).to        be_empty
    expect(content.(gemfile_content)).to      include(gemfile_data)

    expect(content.(env_content)).not_to          be_empty
    expect(content.(cukes_content)).not_to        be_empty
    expect(content.(gemfile_content)).not_to      be_empty
  end

  it 'create a new project with --api_scaffold flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --api_scaffold"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"
    gemfile_content = "#{folder}/Gemfile"
    cukes_content   = "#{folder}/cucumber.yml"

    feature_data = ['Feature: API examples', 'GET']
    steps_data   = ['RestClient::Request', '# Save verb/endpoint/query_params']
    env_data     = ["require 'rest-client'"]

    gemfile_data = "gem 'rest-client'"

    expect(content.(feature_file)).to         include(*feature_data)
    expect(content.(steps_content)).to        include(*steps_data)
    expect(content.(env_content)).to          include(*env_data)
    expect(content.(gemfile_content)).to      include(gemfile_data)
    expect(content.(hooks_content)).to        be_empty
    expect(content.(pages_content)).to        be_empty

    expect(content.(cukes_content)).not_to        be_empty
    expect(content.(gemfile_content)).not_to      be_empty
  end

  it 'create a new project with --ios flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --ios"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"
    launch_content  = "#{folder}/features/support/first_launch.rb"
    dry_content     = "#{folder}/features/support/dry_run.rb"
    gemfile_content = "#{folder}/Gemfile"
    cukes_content   = "#{folder}/cucumber.yml"

    gemfile_data    = 'calabash-cucumber'

    expect(content.(feature_file)).to         be_empty
    expect(content.(steps_content)).to        be_empty
    expect(content.(hooks_content)).to        be_empty
    expect(content.(pages_content)).to        be_empty
    expect(content.(gemfile_content)).to      include(gemfile_data)

    expect(content.(env_content)).not_to          be_empty
    expect(content.(launch_content)).not_to       be_empty
    expect(content.(dry_content)).not_to          be_empty
    expect(content.(cukes_content)).not_to        be_empty
    expect(content.(gemfile_content)).not_to      be_empty
  end

  it 'create a new project with --android flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --android"

    feature_file    = "#{folder}/features/example.feature"
    steps_content   = "#{folder}/features/step_definitions/step_definitions.rb"
    env_content     = "#{folder}/features/support/env.rb"
    hooks_content   = "#{folder}/features/support/hooks.rb"
    pages_content   = "#{folder}/features/support/pages/example.rb"
    life_content    = "#{folder}/features/support/app_life_cycle_hooks.rb"
    app_content     = "#{folder}/features/support/app_installation_hook.rb"
    gemfile_content = "#{folder}/Gemfile"
    cukes_content   = "#{folder}/cucumber.yml"

    gemfile_data    = "gem 'calabash-android'"

    expect(content.(feature_file)).to         be_empty
    expect(content.(steps_content)).to        be_empty
    expect(content.(hooks_content)).to        be_empty
    expect(content.(pages_content)).to        be_empty
    expect(content.(gemfile_content)).to      include(gemfile_data)

    expect(content.(env_content)).not_to          be_empty
    expect(content.(app_content)).not_to          be_empty
    expect(content.(life_content)).not_to         be_empty
    expect(content.(cukes_content)).not_to        be_empty
    expect(content.(gemfile_content)).not_to      be_empty
  end
end
