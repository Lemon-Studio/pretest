require_relative 'unix'

module MacOS
  include Unix
  def set_mac_env
    puts 'Installing/checking HomeBrew'
    mac_update_brew
    puts 'Installing PhantomJS'
    mac_phantomjs_installer
    puts 'Installing ChromeDriver'
    mac_chromedriver_installer
    puts 'Installing/Checking Xcode'
    system 'xcode-select --install > /dev/null'
    puts 'done!'
    puts 'Installing GeckoDriver'
    mac_gecko_installer
  end

  private

  def mac_update_brew
    system "which -s brew
    if [[ $? != 0  ]] ; then
    ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
    fi > /dev/null"
    puts 'done!'
  end

  def mac_chromedriver_installer
    begin
      remove_bin('chromedriver')
      system 'sudo rm -rf chromedriver_mac64.zip' if Dir.entries('.').include?('chromedriver_mac64.zip')
      system 'sudo rm -rf chromedriver_mac64' if Dir.entries('.').include?('chromedriver_mac64')
      system 'sudo curl -OL https://chromedriver.storage.googleapis.com/2.34/chromedriver_mac64.zip'
      system 'sudo unzip chromedriver_mac64.zip > /dev/null'
      system 'sudo chmod +x chromedriver'
      system 'sudo mv -f chromedriver /usr/local/bin'
      system 'sudo rm -rf chromedriver_mac64.zip'
      puts 'done!'
    rescue => e
      puts "Something went wrong with chromedriver instalation, if the following message did not help with the solution, please submit this message to our Repository in 'https://github.com/VilasBoasIT/pretest/issues'\n\n"+
           "#{e}\n\n"
    end
  end

  def mac_gecko_installer
    begin
      remove_bin('geckodriver')
      system 'sudo rm -rf geckodriver-v0.19.1-macos.tar.gz' if Dir.entries('.').include?('geckodriver-v0.19.1-macos.tar.gz')
      system 'sudo rm -rf geckodriver' if Dir.entries('.').include?('geckodriver')
      system 'curl -OL https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-macos.tar.gz'
      system 'sudo tar xvjf geckodriver-v0.19.1-macos.tar.gz'
      system 'sudo chmod +x geckodriver'
      system 'sudo mv -f geckodriver /usr/local/bin'
      system 'sudo rm -rf geckodriver-v0.19.1-macos.tar.gz'
      puts 'done!'
    rescue => e
      puts "Something went wrong with geckodriver instalation, if the following message did not help with the solution, please submit this message to our Repository in 'https://github.com/VilasBoasIT/pretest/issues'\n\n"+
           "#{e}\n\n"
    end
  end

  def mac_phantomjs_installer
    begin
      remove_bin('phantomjs')
      system 'sudo rm -rf phantomjs-2.1.1-macosx.zip' if Dir.entries('.').include?('phantomjs-2.1.1-macosx.zip')
      system 'sudo rm -rf phantomjs-2.1.1-macosx' if Dir.entries('.').include?('phantomjs-2.1.1-macosx')
      system 'sudo curl -OL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-macosx.zip'
      system 'unzip phantomjs-2.1.1-macosx.zip > /dev/null'
      system 'sudo chmod +x phantomjs-2.1.1-macosx/bin/phantomjs'
      system 'sudo mv -f phantomjs-2.1.1-macosx/bin/phantomjs /usr/local/bin'
      system 'sudo rm -rf phantomjs-2.1.1-macosx.zip'
      system 'sudo rm -rf phantomjs-2.1.1-macosx'
      puts 'done!'
    rescue => e
      puts "Something went wrong with phantomjs instalation, if the following message did not help with the solution, please submit this message to our Repository in 'https://github.com/VilasBoasIT/pretest/issues'\n\n"+
           "#{e}\n\n"
    end
  end
end
