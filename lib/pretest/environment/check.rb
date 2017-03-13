require 'pretest/config/operational_system'
require 'thor/group'
require 'rest-client'
require 'zip'
require 'open-uri'
require 'fileutils'
require 'pry'

module Pretest
  module Environment
    class Check < Thor::Group
      include Config
      include Thor::Actions

      desc 'Set, check and show environment variables from the actual Operational System'

      def raise_env
        if linux?
          set_bits
          set_linux_chromedriver
          set_linux_phantomjs
          set_linux_geckodriver
        elsif mac?
          set_mac_env
        elsif windows?
          Dir.mkdir('C:\\env_folder') unless Dir.entries('C:\\').include?('env_folder')
          Dir.chdir('C:\\env_folder')
          system 'setx PATH "%PATH%;C:\\env_folder;C:\\Program Files\\Mozilla Firefox;C:\\Program Files (x86)\\Mozilla Firefox"' unless ENV['PATH'].include?('C:\\env_folder') && ENV['PATH'].include?('C:\\Program Files\\Mozilla Firefox') && ENV['PATH'].include?('C:\\Program Files (x86)\\Mozilla Firefox')
          set_bits
          set_windows_env
          unzip_windows_files
          FileUtils.mv('phantomjs-2.1.1-windows\\bin\\phantomjs.exe', 'C:\\env_folder') unless Dir.entries('C:\\env_folder').include?('phantomjs.exe')
          dk_check_and_install
          puts 'Please reboot your CMD to load the new environment variables'
        end
      end

      no_commands do
        def mac?
          !(/darwin/ =~ RUBY_PLATFORM).nil?
        end

        def windows?
          !(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
        end

        def unix?
          !windows?
        end

        def linux?
          unix? && !mac?
        end
      end # no_commands
    end # Class Check/Thor::Group
  end # module Environment
end # module Pretest
