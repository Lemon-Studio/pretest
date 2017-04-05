module Linux
  def set_linux_chromedriver
    if Dir.entries('/usr/local/share').to_s.include?('chromedriver')
      puts 'ChromeDriver is already installed on the current system'
    else
      system "sudo curl -OL http://chromedriver.storage.googleapis.com/2.23/chromedriver_linux#{@bits}.zip"
      system "sudo unzip chromedriver_linux#{@bits}.zip"
      system 'sudo chmod +x chromedriver'
      system 'sudo mv -f chromedriver /usr/local/share/chromedriver'
      system 'sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver'
      system 'sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver'
      system "sudo rm -rf chromedriver_linux#{@bits}.zip"
    end
  end

  def set_linux_geckodriver
    if Dir.entries('/usr/local/share').to_s.include?('geckodriver')
      puts 'GeckoDriver is already installed on the current system'
    else
      system 'sudo curl -OL https://github.com/mozilla/geckodriver/releases/download/v0.15.0/geckodriver-v0.15.0-linux64.tar.gz'
      system 'sudo tar -xvzf geckodriver-v0.15.0-linux64.tar.gz'
      system 'sudo chmod +x geckodriver'
      system 'sudo mv -f geckodriver /usr/local/share/geckodriver'
      system 'sudo rm -rf geckodriver-v0.15.0-linux64.tar.gz'
    end
  end

  def set_linux_phantomjs
    if Dir.entries('/usr/local/share').to_s.include?('geckodriver')
      puts 'PhantomJS is already installed on the current system'
    else
      system "sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
      system "sudo tar xvjf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
      system "sudo mv -f phantomjs-2.1.1-#{@phantomjs_bits} /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}"
      system "sudo ln -s /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/local/share/phantomjs"
      system "sudo ln -s /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/local/bin/phantomjs"
      system "sudo ln -s /usr/local/share/phantomjs-2.1.1-#{@phantomjs_bits}/bin/phantomjs /usr/bin/phantomjs"
      system "sudo rm -rf phantomjs-2.1.1-#{@phantomjs_bits}.tar.bz2"
    end
  end
end
