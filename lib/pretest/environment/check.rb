require 'thor/group'
require 'rest-client'
require 'zip'
require 'open-uri'
require 'fileutils'

module Pretest

  module Environment

    class Check < Thor::Group

      include Thor::Actions

      desc "Set, check and show environment variables from the actual Operational System"

      def raise_env
        case true #unless check_env == 'true' or show_env == 'true'
        when linux?
          set_bits
          set_linux_chromedriver
          set_linux_phantomjs
        when mac?
          set_mac_env
        when windows?
          Dir.mkdir("C:\\env_folder") unless Dir.entries("C:\\").include?("env_folder")
          Dir.chdir("C:\\env_folder")
          system 'setx PATH "%PATH%;C:\\env_folder"' unless ENV['PATH'].include?("C:\\env_folder")
          set_bits
          set_windows_env
          unzip_windows_files
          FileUtils.mv("phantomjs-2.1.1-windows\\bin\\phantomjs.exe", "C:\\env_folder") unless Dir.entries("C:\\env_folder").include?("phantomjs.exe")
          dk_check_and_install
          puts "Please reboot your CMD to load the new environment variables"
        end
      end

      no_commands do

        def unzip_windows_files
          unzip_file("chromedriver_win32.zip", ".") unless Dir.entries(".").include?("chromedriver.exe")
          unzip_file("phantomjs-2.1.1-windows.zip", ".") unless Dir.entries(".").include?("phantomjs.exe") or File.directory?("phantomjs-2.1.1-windows")
          unzip_file("IEDriverServer_Win32_2.53.1.zip", ".") unless Dir.entries(".").include?("IEDriverServer.exe")
        end

        def set_windows_env
          windows_download("chromedriver_win32.zip", "http://chromedriver.storage.googleapis.com/2.23/chromedriver_win32.zip") unless Dir.entries(".").include?("chromedriver_win32.zip") or Dir.entries(".").include?("chrome.exe")
          windows_download("phantomjs-2.1.1-windows.zip", "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip") unless Dir.entries(".").include?("phantomjs-2.1.1-windows.zip") or Dir.entries(".").include?("phantomjs.exe")
          windows_download("IEDriverServer_Win32_2.53.1.zip", "https://selenium-release.storage.googleapis.com/2.53/IEDriverServer_Win32_2.53.1.zip") unless Dir.entries(".").include?("IEDriverServer_Win32_2.53.1.zip") or Dir.entries(".").include?("IEDriverServer.exe")
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
              :timeout => 10,
              :open_timeout => 10
          )
          response = resource.get
          if response.code == 200
            f = File.new(name, "wb")
            f << response.body
            f.close
            puts "#{name} Download Complete"
          else
            puts "#{name} Download Failed"
            raise("Response Code was not 200: Response Code #{response.code}")
          end
        end

        def dk_check_and_install
          rbenv = ""
          rbpath = ""
          rblist = ""
          rbenv += ENV['PATH']
          rbenv = rbenv.split(";")
          rbenv.each {|rb| if rb.include?("Ruby")
                      rbpath = rb
                      end }
          rbpath = rbpath.gsub!("bin", "lib\\ruby\\site_ruby\\")
          Dir.entries(rbpath).each {|files| rblist << files.to_s}
          if rblist.include?("devkit")
          else
            windows_download("DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe", "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe")
            unzip_install_dk("DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe")
          end
        end

        def unzip_install_dk(file)
          Dir.chdir("C:\\env_folder")
          Dir.mkdir("devkit")
          FileUtils.mv("#{file}", "C:\\env_folder\\devkit\\")
          Dir.chdir("devkit")
          system "#{file} -o '.' -y"
          system "del #{file}"
          system "ruby dk.rb init"
          system "ruby dk.rb install"
        end

        def set_mac_env
         system "which -s brew
         if [[ $? != 0  ]] ; then
         ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
         else
         brew update
         fi"
         system "brew install phantomjs"
         system "brew install chromedriver"
         system "xcode-select --install"
        end

        def set_linux_chromedriver
          system "sudo wget -N http://chromedriver.storage.googleapis.com/2.23/chromedriver_linux#{@bits}.zip"
          system "sudo unzip chromedriver_linux#{@bits}.zip"
          system "sudo chmod +x chromedriver"
          system "sudo mv -f chromedriver /usr/local/share/chromedriver"
          system "sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver"
          system "sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver"
          system "sudo rm -rf chromedriver_linux#{@bits}.zip"
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
          if RUBY_PLATFORM.include?("32")
            @bits = "32" and @phantomjs_bits = "linux-i686"
          else
            @bits = "64" and @phantomjs_bits = "linux-x86_64"
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
          unix? and not mac?
        end

      end

    end

  end

end
