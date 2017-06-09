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
          set_linux_env
        elsif mac?
          set_mac_env
        elsif windows?
          set_bits
          set_windows_env
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
