require 'thor/group'
require 'rest-client'
require 'zip'
require 'open-uri'
require 'fileutils'

module Pretest
  module Environment
    class Check < Thor::Group
      include Thor::Actions

      desc 'Set, check and show environment variables from the actual Operational System'

      def raise_env
        case true # unless check_env == 'true' or show_env == 'true'
        when linux?
          set_bits
          set_linux_chromedriver
          set_linux_phantomjs
        when mac?
          set_mac_env
        when windows?
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
        def unzip_windows_files
          unzip_file('chromedriver_win32.zip', '.') unless Dir.entries('.').include?('chromedriver.exe')
          unzip_file('phantomjs-2.1.1-windows.zip', '.') unless Dir.entries('.').include?('phantomjs.exe') || File.directory?('phantomjs-2.1.1-windows')
          unzip_file('IEDriverServer_Win32_2.53.1.zip', '.') unless Dir.entries('.').include?('IEDriverServer.exe')
        end

        def set_windows_env
          windows_download('chromedriver_win32.zip', 'http://chromedriver.storage.googleapis.com/2.23/chromedriver_win32.zip') unless Dir.entries('.').include?('chromedriver_win32.zip') || Dir.entries('.').include?('chrome.exe')
          windows_download('phantomjs-2.1.1-windows.zip', 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip') unless Dir.entries('.').include?('phantomjs-2.1.1-windows.zip') || Dir.entries('.').include?('phantomjs.exe')
          windows_download('IEDriverServer_Win32_2.53.1.zip', 'https://selenium-release.storage.googleapis.com/2.53/IEDriverServer_Win32_2.53.1.zip') unless Dir.entries('.').include?('IEDriverServer_Win32_2.53.1.zip') || Dir.entries('.').include?('IEDriverServer.exe')
        end

        def unzip_file(file, destination)
          Zip::File.open(file) do |zip_file|
            zip_file.each do |f|
              f_path = File.join(destination, f.name)
              FileUtils.mkdir_p(File.dirname(f_path))
              f.extract(f_path)
            end
          end
          system "del #{file}"
        end

        def windows_download(name, url)
          zipfile = url
          resource = RestClient::Resource.new(
            zipfile,
            timeout: 60,
            open_timeout: 60
          )
          response = resource.get
          if response.code == 200
            f = File.new(name, 'wb')
            f << response.body
            f.close
            puts "#{name} Download Complete"
          else
            puts "#{name} Download Failed"
            raise("Response Code was not 200: Response Code #{response.code}")
          end
        end

        def dk_check_and_install
          rbenv = ''
          rbpath = ''
          rblist = ''
          rbenv += ENV['PATH']
          if ENV['PATH'].include?('Ruby') == false
            raise 'There is no Ruby environment variable defined in current PATH'
          end
          rbenv = rbenv.split(';')
          rbenv.each do |rb|
            rbpath = rb if rb.include?('Ruby')
          end
          rbpath = rbpath.gsub!('bin', 'lib\\ruby\\site_ruby\\')
          Dir.entries(rbpath).each { |files| rblist << files.to_s }
          if rblist.include?('devkit')
          else
            windows_download('DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe', 'http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe')
            unzip_install_dk('DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe')
          end
        end

        def unzip_install_dk(file)
          Dir.chdir('C:\\env_folder')
          Dir.mkdir('devkit')
          FileUtils.mv(file.to_s, 'C:\\env_folder\\devkit\\')
          Dir.chdir('devkit')
          system "#{file} -o '.' -y"
          system "del #{file}"
          system 'ruby dk.rb init'
          system 'ruby dk.rb install'
        end

        def set_mac_env
          system "which -s brew
          if [[ $? != 0  ]] ; then
          ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
          else
          brew update
          fi"
          system 'brew install phantomjs'
          system 'brew install chromedriver'
          system 'xcode-select --install'
          mac_gecko_installer
        end

        def mac_gecko_installer
          system 'curl -OL https://github.com/mozilla/geckodriver/releases/download/v0.15.0/geckodriver-v0.15.0-macos.tar.gz'
          system 'sudo tar xvjf geckodriver-v0.15.0-macos.tar.gz'
          system 'sudo chmod +x geckodriver'
          system 'sudo mv -f geckodriver /usr/local/share/geckodriver'
          system 'sudo rm -rf geckodriver-v0.15.0-macos.tar.gz'
          check_gecko_environment_variables
        end

        def check_gecko_environment_variables
          set_gecko_env_variables
          File.new("#{ENV['HOME']}/.pretest", 'w') unless Dir.entries(ENV['HOME']).include?('.pretest')
          if File.read("#{ENV['HOME']}/.pretest").include?('GECKO_DRIVER')
            puts 'GeckoDriver Home is already defined'
          else
            File.open("#{ENV['HOME']}/.pretest", 'a') { |file| file << @gecko_driver }
            File.open("#{ENV['HOME']}/.bash_profile", 'a') { |file| file << @set_source }
            system 'source ~/.bash_profile'
            puts 'GeckoDriver defined with success'
          end
          system 'source ~/.pretest'
        end

        def set_gecko_env_variables
          @gecko_driver = "\n\n# Set Gecko Driver Path
export GECKO_DRIVER='/usr/local/share'
export PATH='${PATH}:${GECKO_DRIVER}/geckodriver'
export PATH='${PATH}:${GECKO_DRIVER}'".tr!("'", '"')
          @set_source = "\n[[ -s '$HOME/.pretest'  ]] && source '$HOME/.pretest' # Load environment variables defined in pretest".tr!("'", '"')
        end

        def set_linux_chromedriver
          system "sudo wget -N http://chromedriver.storage.googleapis.com/2.23/chromedriver_linux#{@bits}.zip"
          system "sudo unzip chromedriver_linux#{@bits}.zip"
          system 'sudo chmod +x chromedriver'
          system 'sudo mv -f chromedriver /usr/local/share/chromedriver'
          system 'sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver'
          system 'sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver'
          system "sudo rm -rf chromedriver_linux#{@bits}.zip"
        end

        def set_linux_geckodriver
          system 'sudo wget -N https://github.com/mozilla/geckodriver/releases/download/v0.15.0/geckodriver-v0.15.0-linux64.tar.gz'
          system 'sudo tar xvjf geckodriver-v0.15.0-linux64.tar.gz'
          system 'sudo mv -f geckodriver /usr/local/share/geckodriver'
          system 'sudo ln -s /usr/local/share/geckodriver /usr/local/bin/geckodriver'
          system 'sudo rm -rf geckodriver-v0.15.0-linux64.tar.gz'
        end

        def set_linux_phantomjs
          system "sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
          system "sudo tar xvjf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
          system "sudo mv -f phantomjs-2.1.1-#{@phantomjs_bits} /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}"
          system "sudo ln -s /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/local/share/phantomjs"
          system "sudo ln -s /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/local/bin/phantomjs"
          system "sudo ln -s /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/bin/phantomjs"
          system "sudo rm -rf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
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
      end
    end
  end
end
