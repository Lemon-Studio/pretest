require 'spec_helper'

describe Pretest do

  before(:each) do
    @dir = Dir.mktmpdir("pretest")
    Dir.chdir(@dir)
  end

  after(:each) do
    FileUtils.rm_rf(@dir)
  end

  it 'creates a new empty project' do
    folder = "pretest_spec"
    system "pretest create #{folder}"

    expect(Dir.entries(folder)).to include("cucumber.yml", "data", "features", "Gemfile")
    expect(Dir.entries("#{folder}/features")).to include("example.feature", "step_definitions", "support")
    expect(Dir.entries("#{folder}/features/step_definitions")).to include("step_definitions.rb")
    expect(Dir.entries("#{folder}/features/support")).to include("env.rb", "hooks.rb", "pages")
    expect(Dir.entries("#{folder}/features/support/pages")).to include("example.rb")
  end

  it 'creates a new empty project with invalid args' do
    folder = "pretest_spec"
    system "pretest create #{folder} name"

    expect(Dir.entries(".")).not_to include("#{folder} name")
  end

  it 'creates a new project and check his content' do
    folder = "pretest_spec"
    system "pretest create #{folder}"

    expect(File.read("#{folder}/Gemfile").strip).to include(CONFIG_DATA['gemfile']['web'].strip)
    expect(File.read("#{folder}/features/support/env.rb").strip).to include(CONFIG_DATA['features']['support']['env_web'].strip)
    expect(File.read("#{folder}/cucumber.yml").strip).to include(CONFIG_DATA['cucumber'].strip)
    expect(File.read("#{folder}/features/support/pages/example.rb").strip).not_to include(CONFIG_DATA['features']['support']['pages']['pages_web'].strip)
    expect(File.read("#{folder}/features/example.feature").strip).not_to include(CONFIG_DATA['features']['features_web'].strip)
    expect(File.read("#{folder}/features/step_definitions/step_definitions.rb").strip).not_to include(CONFIG_DATA['features']['step_definitions']['steps_web'].strip)
  end

  it 'creates a new project with web_scaffold and check his content' do
    folder = "pretest_spec"
    system "pretest create #{folder} --web_scaffold"

    expect(File.read("#{folder}/cucumber.yml").strip).to include(CONFIG_DATA['cucumber'].strip)
    expect(File.read("#{folder}/Gemfile").strip).to include(CONFIG_DATA['gemfile']['web'].strip)
    expect(File.read("#{folder}/features/support/env.rb").strip).to include(CONFIG_DATA['features']['support']['env_web'].strip)
    expect(File.read("#{folder}/features/support/pages/example.rb").strip).to include(CONFIG_DATA['features']['support']['pages']['pages_web'].strip)
    expect(File.read("#{folder}/features/example.feature").strip).to include(CONFIG_DATA['features']['features_web'].strip)
    expect(File.read("#{folder}/features/step_definitions/step_definitions.rb").strip).to include(CONFIG_DATA['features']['step_definitions']['steps_web'].strip)
  end

end
