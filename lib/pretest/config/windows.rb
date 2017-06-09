require 'fileutils'

module Windows
  def set_windows_env
    Dir.mkdir('C:\\env_folder') unless Dir.entries('C:\\').include?('env_folder')
    Dir.chdir('C:\\env_folder')
    @ruby = get_ruby_path
    puts 'Downloading webdrivers to C:\\env_folder'
    windows_download
    puts 'Unziping webdrivers files'
    unzip_windows_files
    puts 'Checking Ruby Development Kit...'
    dk_check_and_install
    move_webdrivers
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
    Dir.chdir('C:\\env_folder')

    FileUtils.rm_rf('phantomjs-2.1.1-windows.zip') if Dir.entries('.').include?('phantomjs-2.1.1-windows.zip')
    FileUtils.rm_rf('IEDriverServer_Win32_3.4.0.zip') if Dir.entries('.').include?('IEDriverServer_Win32_3.4.0.zip')
    FileUtils.rm_rf("geckodriver-v0.16.1-win#{@bits}.zip") if Dir.entries('.').include?("geckodriver-v0.16.1-win#{@bits}.zip")
    FileUtils.rm_rf('chromedriver_win32.zip') if Dir.entries('.').include?('chromedriver_win32.zip')

    FileUtils.rm_rf('chromedriver.exe') if Dir.entries('.').include?('chromedriver.exe')
    FileUtils.rm_rf('IEDriverServer.exe') if Dir.entries('.').include?('IEDriverServer.exe')
    FileUtils.rm_rf('geckodriver.exe') if Dir.entries('.').include?('geckodriver.exe')
    FileUtils.rm_rf('phantomjs-2.1.1-windows') if Dir.entries('.').include?('phantomjs-2.1.1-windows')
    FileUtils.rm_rf('phantomjs.exe') if Dir.entries('.').include?('phantomjs-2.1.1-windows')

    zip_download('chromedriver_win32.zip', 'https://chromedriver.storage.googleapis.com/2.30/chromedriver_win32.zip') unless Dir.entries('.').include?('chromedriver_win32.zip') || Dir.entries('.').include?('chrome.exe')
    zip_download('phantomjs-2.1.1-windows.zip', 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip') unless Dir.entries('.').include?('phantomjs-2.1.1-windows.zip') || Dir.entries('.').include?('phantomjs.exe')
    zip_download('IEDriverServer_Win32_3.4.0.zip', 'http://selenium-release.storage.googleapis.com/3.4/IEDriverServer_Win32_3.4.0.zip') unless Dir.entries('.').include?('IEDriverServer_Win32_3.4.0.zip') || Dir.entries('.').include?('IEDriverServer.exe')
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
    FileUtils.rm_rf("#{@ruby}}\\phantomjs.exe") if Dir.entries(@ruby).include?('phantomjs.exe')
    FileUtils.rm_rf("#{@ruby}}\\geckodriver.exe") if Dir.entries(@ruby).include?('geckodriver.exe')
    FileUtils.rm_rf("#{@ruby}}\\chromedriver.exe") if Dir.entries(@ruby).include?('chromedriver.exe')
    FileUtils.rm_rf("#{@ruby}}\\IEDriverServer.exe") if Dir.entries(@ruby).include?('IEDriverServer.exe')

    FileUtils.mv('C:\\env_folder\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe', @ruby)
    FileUtils.mv('C:\\env_folder\\chromedriver.exe', @ruby)
    FileUtils.mv('C:\\env_folder\\IEDriverServer.exe', @ruby)
    FileUtils.mv('C:\\env_folder\\geckodriver.exe', @ruby)

    FileUtils.rm_rf('C:\\env_folder\\phantomjs-2.1.1-windows') if Dir.entries('.').include?('phantomjs-2.1.1-windows')
  end

  def get_ruby_path
    env = ENV['PATH'].split(';')
    rb_path = env.each do |path|
      return path if path.upcase.include?('RUBY') && path.upcase.include?('BIN')
    end
    raise "We couldn't locate the ruby installed on the current machine" if rb_path.nil?
    puts "We're going to move the webdrivers to '#{rb_path}'"
    rb_path
  end
end
