require 'fileutils'

module Windows
  def set_windows_env
    Dir.mkdir('C:\\env_folder') unless Dir.entries('C:\\').include?('env_folder')
    Dir.chdir('C:\\env_folder')
    puts 'Downloading webdrivers to C:\\env_folder'
    windows_download
    puts 'Unziping webdrivers files'
    unzip_windows_files
    FileUtils.mv('C:\\env_folder\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe', 'C:\\windows') unless Dir.entries('C:\\windows').include?('phantomjs.exe')
    puts 'Checking Ruby Development Kit...'
    dk_check_and_install
    puts 'Please reboot your CMD to load the new environment variables'
  end

  private

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

  def zip_download(name, url)
    zipfile = url
    resource = RestClient::Resource.new(
      zipfile,
      timeout: 120,
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

  def windows_download
    set_bits
    FileUtils.rm_rf('chromedriver_win32.zip') if Dir.entries('.').include?('chromedriver_win32.zip')
    zip_download('chromedriver_win32.zip', 'https://chromedriver.storage.googleapis.com/2.30/chromedriver_win32.zip') unless Dir.entries('.').include?('chromedriver_win32.zip') || Dir.entries('.').include?('chrome.exe')
    FileUtils.rm_rf('phantomjs-2.1.1-windows.zip') if Dir.entries('.').include?('phantomjs-2.1.1-windows.zip')
    zip_download('phantomjs-2.1.1-windows.zip', 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip') unless Dir.entries('.').include?('phantomjs-2.1.1-windows.zip') || Dir.entries('.').include?('phantomjs.exe')
    FileUtils.rm_rf('IEDriverServer_Win32_3.4.0.zip') if Dir.entries('.').include?('IEDriverServer_Win32_3.4.0.zip')
    zip_download('IEDriverServer_Win32_3.4.0.zip', 'http://selenium-release.storage.googleapis.com/3.4/IEDriverServer_Win32_3.4.0.zip') unless Dir.entries('.').include?('IEDriverServer_Win32_3.4.0.zip') || Dir.entries('.').include?('IEDriverServer.exe')
    FileUtils.rm_rf("geckodriver-v0.16.1-win#{@bits}.zip") if Dir.entries('.').include?("geckodriver-v0.16.1-win#{@bits}.zip")
    zip_download("geckodriver-v0.16.1-win#{@bits}.zip", "https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-win#{@bits}.zip") unless Dir.entries('.').include?("geckodriver-v0.16.1-win#{@bits}") || Dir.entries('.').include?('geckodriver.exe')
  end

  def unzip_windows_files
    set_bits
    unzip_file('chromedriver_win32.zip', '.') unless Dir.entries('.').include?('chromedriver.exe')
    unzip_file('phantomjs-2.1.1-windows.zip', '.') unless Dir.entries('.').include?('phantomjs.exe') || File.directory?('phantomjs-2.1.1-windows')
    unzip_file('IEDriverServer_Win32_3.4.0.zip', '.') unless Dir.entries('.').include?('IEDriverServer.exe')
    unzip_file("geckodriver-v0.16.1-win#{@bits}.zip", '.') unless Dir.entries('.').include?('geckodriver.exe')
  end

  # # This is going to be a new feature.
  # def remove_windows_duplicated_values
  #   path = ENV['PATH'].clone
  #   path = path.split(';')
  #   path = path.uniq
  #   path = path.join(';')
  #   path
  # end

  def dk_check_and_install
    set_bits
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
      zip_download("DevKit-mingw64-#{@devkit}-sfx.exe", "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-#{@devkit}-sfx.exe")
      unzip_install_dk("DevKit-mingw64-#{@devkit}-sfx.exe")
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

  def move_webdrivers
    FileUtils.rm_rf('C:\\windows\\phantomjs.exe') if Dir.entries('C:\\windows').include?('phantomjs.exe')
    FileUtils.mv('phantomjs-2.1.1-windows\\bin\\phantomjs.exe', 'C:\\windows')
    FileUtils.rm_rf('phantomjs-2.1.1-windows') if Dir.entries('.').include?('phantomjs-2.1.1-windows')
    FileUtils.rm_rf('C:\\windows\\chromedriver.exe') if Dir.entries('C:\\windows').include?('chromedriver.exe')
    FileUtils.mv('chromedriver.exe', 'C:\\windows')
    FileUtils.rm_rf('C:\\windows\\geckodriver.exe') if Dir.entries('C:\\windows').include?('geckodriver.exe')
    FileUtils.mv('geckodriver.exe', 'C:\\windows')
  end
end
