module Windows
  def unzip_windows_files
    set_bits
    unzip_file('chromedriver_win32.zip', '.') unless Dir.entries('.').include?('chromedriver.exe')
    unzip_file('phantomjs-2.1.1-windows.zip', '.') unless Dir.entries('.').include?('phantomjs.exe') || File.directory?('phantomjs-2.1.1-windows')
    unzip_file('IEDriverServer_Win32_2.53.1.zip', '.') unless Dir.entries('.').include?('IEDriverServer.exe')
    unzip_file("geckodriver-v0.15.0-win#{@bits}", '.') unless Dir.entries('.').include?('geckodriver.exe')
  end

  def set_windows_env
    set_bits
    windows_download('chromedriver_win32.zip', 'https://chromedriver.storage.googleapis.com/2.28/chromedriver_win32.zip') unless Dir.entries('.').include?('chromedriver_win32.zip') || Dir.entries('.').include?('chrome.exe')
    windows_download('phantomjs-2.1.1-windows.zip', 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-windows.zip') unless Dir.entries('.').include?('phantomjs-2.1.1-windows.zip') || Dir.entries('.').include?('phantomjs.exe')
    windows_download('IEDriverServer_Win32_2.53.1.zip', 'https://selenium-release.storage.googleapis.com/2.53/IEDriverServer_Win32_2.53.1.zip') unless Dir.entries('.').include?('IEDriverServer_Win32_2.53.1.zip') || Dir.entries('.').include?('IEDriverServer.exe')
    windows_download("geckodriver-v0.15.0-win#{@bits}", "https://github.com/mozilla/geckodriver/releases/download/v0.15.0/geckodriver-v0.15.0-win#{@bits}.zip") unless Dir.entries('.').include?("geckodriver-v0.15.0-win#{@bits}") || Dir.entries('.').include?('geckodriver.exe')
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

  def remove_windows_duplicated_values
    path = ENV['PATH'].clone
    path = path.split(';')
    path = path.uniq
    path = path.join(';')
    path += ';C:\\env_folder'
    path
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
      windows_download("DevKit-mingw64-#{@devkit}-sfx.exe", "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-#{@devkit}-sfx.exe")
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
end
