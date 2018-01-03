require 'spec_helper'
require 'open3'

describe 'Pretest FileTree Checker' do
  before(:each) do
    @current_dir = Dir.pwd
    @dir = Dir.mktmpdir('pretest')
    Dir.chdir(@dir)
  end

  dirs = ->(dir) { Dir.entries(dir) }

  after(:each) do
    FileUtils.rm_rf(@dir)
    Dir.chdir(@current_dir)
  end

  it 'creates a new empty project and check his fileTree' do
    folder = 'pretest_spec'
    system "pretest create #{folder}"

    features         = "#{folder}/features"
    step_definitions = "#{folder}/features/step_definitions"
    support          = "#{folder}/features/support"
    pages            = "#{folder}/features/support/pages"

    root_dir     = %w[cucumber.yml data features Gemfile]
    features_dir = %w[example.feature step_definitions support]
    steps_dir    = %w[step_definitions.rb]
    support_dir  = %w[env.rb hooks.rb pages]
    pages_dir    = %w[example.rb]

    mobile_dir   = %w[app_installation_hook.rb app_life_cycle_hooks.rb
                      dry_run.rb first_launch.rb]

    expect(dirs.(folder)).to           include(*root_dir)
    expect(dirs.(features)).to         include(*features_dir)
    expect(dirs.(step_definitions)).to include(*steps_dir)
    expect(dirs.(support)).to          include(*support_dir)
    expect(dirs.(pages)).to            include(*pages_dir)

    expect(dirs.(support)).not_to      include(*mobile_dir)
  end

  it 'creates a new project with --web_scaffold flag and check his fileTree' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --web_scaffold"

    features         = "#{folder}/features"
    step_definitions = "#{folder}/features/step_definitions"
    support          = "#{folder}/features/support"
    pages            = "#{folder}/features/support/pages"

    root_dir     = %w[cucumber.yml data features Gemfile]
    features_dir = %w[example.feature step_definitions support]
    steps_dir    = %w[step_definitions.rb]
    support_dir  = %w[env.rb hooks.rb pages]
    pages_dir    = %w[example.rb]

    mobile_dir   = %w[app_installation_hook.rb app_life_cycle_hooks.rb
                      dry_run.rb first_launch.rb]

    expect(dirs.(folder)).to           include(*root_dir)
    expect(dirs.(features)).to         include(*features_dir)
    expect(dirs.(step_definitions)).to include(*steps_dir)
    expect(dirs.(support)).to          include(*support_dir)
    expect(dirs.(pages)).to            include(*pages_dir)

    expect(dirs.(support)).not_to      include(*mobile_dir)
  end

  it 'create a new project with --api flag and check his content' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --api"

    features         = "#{folder}/features"
    step_definitions = "#{folder}/features/step_definitions"
    support          = "#{folder}/features/support"
    pages            = "#{folder}/features/support/pages"

    root_dir     = %w[cucumber.yml data features Gemfile]
    features_dir = %w[example.feature step_definitions support]
    steps_dir    = %w[step_definitions.rb]
    support_dir  = %w[env.rb hooks.rb pages]
    pages_dir    = %w[example.rb]

    mobile_dir   = %w[app_installation_hook.rb app_life_cycle_hooks.rb
                      dry_run.rb first_launch.rb]

    expect(dirs.(folder)).to           include(*root_dir)
    expect(dirs.(features)).to         include(*features_dir)
    expect(dirs.(step_definitions)).to include(*steps_dir)
    expect(dirs.(support)).to          include(*support_dir)
    expect(dirs.(pages)).to            include(*pages_dir)

    expect(dirs.(support)).not_to      include(*mobile_dir)
  end

  it 'create a new project with --api_scaffold flag and check his fileTree' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --api_scaffold"

    features         = "#{folder}/features"
    step_definitions = "#{folder}/features/step_definitions"
    support          = "#{folder}/features/support"
    pages            = "#{folder}/features/support/pages"

    root_dir     = %w[cucumber.yml data features Gemfile]
    features_dir = %w[example.feature step_definitions support]
    steps_dir    = %w[step_definitions.rb]
    support_dir  = %w[env.rb hooks.rb pages]
    pages_dir    = %w[example.rb]

    mobile_dir   = %w[app_installation_hook.rb app_life_cycle_hooks.rb
                      dry_run.rb first_launch.rb]

    expect(dirs.(folder)).to           include(*root_dir)
    expect(dirs.(features)).to         include(*features_dir)
    expect(dirs.(step_definitions)).to include(*steps_dir)
    expect(dirs.(support)).to          include(*support_dir)
    expect(dirs.(pages)).to            include(*pages_dir)

    expect(dirs.(support)).not_to      include(*mobile_dir)
  end

  it 'create a new project with --ios flag and check his fileTree' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --ios"

    features         = "#{folder}/features"
    step_definitions = "#{folder}/features/step_definitions"
    support          = "#{folder}/features/support"
    pages            = "#{folder}/features/support/pages"

    root_dir     = %w[cucumber.yml data features Gemfile]
    features_dir = %w[example.feature step_definitions support]
    steps_dir    = %w[step_definitions.rb]
    support_dir  = %w[env.rb hooks.rb pages]
    pages_dir    = %w[example.rb]

    ios          = %w[first_launch.rb dry_run.rb]
    android      = %w[app_installation_hook.rb app_life_cycle_hooks.rb]

    expect(dirs.(folder)).to           include(*root_dir)
    expect(dirs.(features)).to         include(*features_dir)
    expect(dirs.(step_definitions)).to include(*steps_dir)
    expect(dirs.(support)).to          include(*support_dir)
    expect(dirs.(support)).to          include(*ios)

    expect(dirs.(support)).not_to      include(*android)
  end

  it 'create a new project with --android flag and check his fileTree' do
    folder = 'pretest_spec'
    system "pretest create #{folder} --android"

    features         = "#{folder}/features"
    step_definitions = "#{folder}/features/step_definitions"
    support          = "#{folder}/features/support"
    pages            = "#{folder}/features/support/pages"

    root_dir     = %w[cucumber.yml data features Gemfile]
    features_dir = %w[example.feature step_definitions support]
    steps_dir    = %w[step_definitions.rb]
    support_dir  = %w[env.rb hooks.rb pages]
    pages_dir    = %w[example.rb]

    ios          = %w[first_launch.rb dry_run.rb]
    android      = %w[app_installation_hook.rb app_life_cycle_hooks.rb]

    expect(dirs.(folder)).to           include(*root_dir)
    expect(dirs.(features)).to         include(*features_dir)
    expect(dirs.(step_definitions)).to include(*steps_dir)
    expect(dirs.(support)).to          include(*support_dir)
    expect(dirs.(pages)).to            include(*pages_dir)
    expect(dirs.(support)).to          include(*android)

    expect(dirs.(support)).not_to      include(*ios)
  end

  it 'creates a new empty project with invalid args' do
    folder   = 'pretest_spec'
    dir_name = "#{folder} name"

    log, val = Open3.capture2e("pretest create #{dir_name}")
    log = log.to_s

    expect(log).to include('ERROR')
    expect(dirs.('.')).not_to include(dir_name)
  end
end
