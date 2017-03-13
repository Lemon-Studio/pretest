
require_relative 'mac'
require_relative 'linux'
require_relative 'windows'
require_relative 'unix'

module Config
  include MacOS
  include Linux
  include Windows
  include Unix
  def mac?
    !(/darwin/ =~ RUBY_PLATFORM).nil?
  end

  def windows?
    !(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  end

  def unix?
    !windows?
  end

  def linux?
    unix? && !mac?
  end

  def set_bits
    if RUBY_PLATFORM.include?('32') && !RUBY_PLATFORM.include?('64')
      (@bits = '32') && (@phantomjs_bits = 'linux-i686') && (@devkit = '32-4.7.2-20130224-1151')
    else
      (@bits = '64') && (@phantomjs_bits = 'linux-x86_64') && (@devkit = '64-4.7.2-20130224-1432')
    end
  end
end
