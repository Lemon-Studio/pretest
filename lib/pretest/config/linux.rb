require_relative 'unix'

module Linux
  include Unix
  def set_linux_env
    puts 'Installing ChromeDriver'
    set_linux_chromedriver
    puts 'Installing PhantomJS'
    set_linux_phantomjs
    puts 'Installing GeckoDriver'
    set_linux_geckodriver
  end

  private

  def set_linux_chromedriver
    remove_bin('chromedriver')
    system "sudo rm -rf chromedriver_linux#{@bits}.zip" if Dir.entries('.').include?("chromedriver_linux#{@bits}.zip")
    system "sudo rm -rf chromedriver_linux#{@bits}" if Dir.entries('.').include?("chromedriver_linux#{@bits}")
    system "sudo curl -OL http://chromedriver.storage.googleapis.com/2.30/chromedriver_linux#{@bits}.zip"
    system "sudo unzip chromedriver_linux#{@bits}.zip"
    system 'sudo chmod +x chromedriver'
    system 'sudo mv -f chromedriver /usr/local/bin/chromedriver'
    system "sudo rm -rf chromedriver_linux#{@bits}.zip"
    puts 'done!'
  end

  def set_linux_geckodriver
    remove_bin('geckodriver')
    system 'sudo rm -rf geckodriver-v0.16.1-linux64.tar.gz' if Dir.entries('.').include?('geckodriver-v0.16.1-linux64.tar.gz')
    system 'sudo rm -rf geckodriver-v0.16.1-linux64' if Dir.entries('.').include?('geckodriver-v0.16.1-linux64')
    system 'sudo curl -OL https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz'
    system 'sudo tar -xvzf geckodriver-v0.16.1-linux64.tar.gz'
    system 'sudo chmod +x geckodriver'
    system 'sudo mv -f geckodriver /usr/local/bin/geckodriver'
    system 'sudo rm -rf geckodriver-v0.16.1-linux64.tar.gz'
    puts 'done!'
  end

  def set_linux_phantomjs
    remove_bin('phantomjs')
    system "sudo rm -rf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2" if Dir.entries('.').include?("phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2")
    system "sudo rm -rf phantomjs-2.1.1-#{@phantomjs_bits}" if Dir.entries('.').include?("phantomjs-2.1.1-#{@phantomjs_bits}")
    system "sudo curl -OL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
    system "sudo tar xvjf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2 > /dev/null"
    system "sudo chmod +x phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs"
    system "sudo mv -f phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/local/bin"
    system "sudo rm -rf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
    puts 'done!'
  end
end
