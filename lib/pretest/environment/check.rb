require 'thor/group'
require 'rest-client'
require 'zip'
require 'nokogiri'
require 'open-uri'

module Pretest

  module Environment

    class Check < Thor::Group

      include Thor::Actions

      #argument :set_env, type: :string, desc: "Set environment variables with the actual OS"
      #argument :check_env, type: :string, desc: "Check environment variables from the actual OS"
      #argument :show_env, type: :string, desc: "Show environment variables from the actual OS"

      desc "Set, check and show environment variables from the actual Operational System"

      def raise_env
        case true #unless check_env == 'true' or show_env == 'true'
        when linux?
          set_versions
          set_bits
          set_linux_chromedriver
          set_linux_phantomjs
        when mac?
          set_mac_env
        when windows?
          set_versions
          set_bits
          set_windows_env
          unzip_files("chromedriver_win32.zip", ".")
          unzip_files("phantomjs-#{@phantomjs_version}-windows.zip", ".")
          system "move chromedriver.exe C:\\env_folder"
          system "move phantomjs-#{@phantomjs_version}-windows C:\\env_folder"
          system "copy C:\\env_folder\\phantomjs-#{@phantomjs_version}-windows\\bin\\phantomjs.exe C:\\env_folder"
        end
      end

      no_commands do

        def set_windows_env
          windows_download("chromedriver_win32.zip", "http://chromedriver.storage.googleapis.com/#{@chrome_version}/chromedriver_win32.zip")
          windows_download("phantomjs-#{@phantomjs_version}-windows.zip", "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{@phantomjs_version}-windows.zip")
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
              :timeout => nil,
              :open_timeout => nil
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

        def set_mac_env
         system "which -s brew
         if [[ $? != 0  ]] ; then
         ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
         else
         brew update
         fi"
         sleep(10)
         system "clear"
         system "brew install phantomjs"
         system "brew install chromedriver"
        end

        def set_linux_chromedriver
          system "sudo wget -N http://chromedriver.storage.googleapis.com/#{@chrome_version}/chromedriver_linux#{@bits}.zip"
          system "sudo unzip chromedriver_linux#{@bits}.zip"
          system "sudo chmod +x chromedriver"
          system "sudo mv -f chromedriver /usr/local/share/chromedriver"
          system "sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver"
          system "sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver"
          system "sudo rm -rf chromedriver_linux#{@bits}.zip"
        end

        def set_linux_phantomjs
          system "sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}.tar.bz2"
          system "sudo tar xvjf phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}.tar.bz2"
          system "sudo mv -f phantomjs-#{@phantomjs_version}-#{@phantomjs_bits} /usr/local/share/phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}"
          system "sudo ln -s /usr/local/share/phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}/bin/phantomjs /usr/local/share/phantomjs"
          system "sudo ln -s /usr/local/share/phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}/bin/phantomjs /usr/local/bin/phantomjs"
          system "sudo ln -s /usr/local/share/phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}/bin/phantomjs /usr/bin/phantomjs"
          system "sudo rm -rf phantomjs-#{@phantomjs_version}-#{@phantomjs_bits}.tar.bz2"
        end

        def set_versions
          chrome_release = Nokogiri::HTML(open("http://chromedriver.storage.googleapis.com/LATEST_RELEASE"))
          @chrome_version = chrome_release.text
          phantomjs_release = Nokogiri::HTML(open("http://phantomjs.org/download.html"))
          pre_version = phantomjs_release.css('div p a')[0].text
          @phantomjs_version = pre_version[10..14]
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
