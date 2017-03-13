module MacOS
  def set_mac_env
    puts 'Installing/updating HomeBrew'
    system "which -s brew
    if [[ $? != 0  ]] ; then
    ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
    else
    brew update
    fi > /dev/null"
    system 'brew install phantomjs > /dev/null'
    puts 'Installing PhantomJS'
    system 'brew install chromedriver > /dev/null'
    puts 'Installing ChromeDriver'
    system 'xcode-select --install > /dev/null'
    puts 'Installing/Checking Xcode'
    mac_gecko_installer
  end

  def mac_gecko_installer
    puts 'Installing GeckoDriver'
    system 'curl -OL https://github.com/mozilla/geckodriver/releases/download/v0.15.0/geckodriver-v0.15.0-macos.tar.gz'
    system 'sudo tar xvjf geckodriver-v0.15.0-macos.tar.gz > /dev/null'
    system 'sudo chmod +x geckodriver > /dev/null'
    system 'sudo mv -f geckodriver /usr/local/share/geckodriver > /dev/null'
    system 'sudo rm -rf geckodriver-v0.15.0-macos.tar.gz > /dev/null'
    check_gecko_environment_variables
  end
end
