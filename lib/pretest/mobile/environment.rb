require 'thor/group'
require 'rest-client'
require 'open-uri'
require 'fileutils'

module Pretest
  module Mobile
    class Environment < Thor::Group
      include Thor::Actions

      argument :env, type: :string, desc: 'Environment to configure'

      desc 'Check, configure and install environment with de defined argument'

      def set_mobile_environment
        if linux? || mac?
          mobile_env
        elsif windows?
        end
      end

      no_commands do
        def mobile_env
          if env == 'android'
            set_android_env
          elsif env == 'ios'
            # set_ios_env
          elsif (env != 'ios') && (env != 'android')
            puts "You must use one of the following arguments:\n
  android:\t # pretest mobile_environment android
  ios:\t\t # pretest mobile_environment ios"
          end
        end

        def set_environment_values
          @android_studio = "\n\n#Android sdk set path
export ANDROID_HOME='/usr/local/opt/android-sdk'
export PATH='${PATH}:${ANDROID_HOME}/tools'".tr!("'", '"')
          @set_source = "\n[[ -s '$HOME/.pretest'  ]] && source '$HOME/.pretest' # Load environment variables defined in pretest".tr!("'", '"')
        end

        def set_android_env
          set_environment_values
          File.new("#{ENV['HOME']}/.pretest", 'w') unless Dir.entries(ENV['HOME']).include?('.pretest')
          if File.read("#{ENV['HOME']}/.pretest").include?('ANDROID_HOME')
            puts 'ANDROID_HOME is already defined'
          else
            File.open("#{ENV['HOME']}/.pretest", 'a') { |file| file << @android_studio }
            File.open("#{ENV['HOME']}/.bashrc", 'a') { |file| file << @set_source }
            system 'source ~/.bashrc'
            puts 'ANDROID_HOME defined with success'
          end
        end

        def set_bits
          if RUBY_PLATFORM.include?('32')
            (@bits = '32') && (@phantomjs_bits = 'linux-i686')
          else
            (@bits = '64') && (@phantomjs_bits = 'linux-x86_64')
          end
        end

        def mac?
          (/darwin/ =~ RUBY_PLATFORM) != nil
        end

        def windows?
          (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
        end

        def unix?
          !windows?
        end

        def linux?
          unix? && !mac?
        end
      end # no_commands
    end # class Environment/Thor::Group
  end # module Mobile
end # module Pretest
