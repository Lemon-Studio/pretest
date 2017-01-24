require 'calabash-cucumber/launcher'

module Calabash::Launcher
  @@launcher = nil

  def self.launcher
    @@launcher ||= Calabash::Cucumber::Launcher.new
  end

  def self.launcher=(launcher)
    @@launcher = launcher
  end
end

Before do |scenario|
  launcher = Calabash::Launcher.launcher
  options = {
    # Add launch options here.
  }

  launcher.relaunch(options)
end

After do |scenario|
  if launcher.quit_app_after_scenario?
    calabash_exit
  end
end
