require 'rest-client'
require 'open-uri'
require 'fileutils'
require 'open3'
require 'pry'

module Unix
  def remove_bin(file)
    output, _status = Open3.capture2("which #{file}")
    return false if output.nil?
    return false if output.empty?

    output = output.delete("\n") unless output.empty?
    until output.empty?
      system "sudo rm -rf #{output}"
      output, _status = Open3.capture2("which #{file}").delete("\n")
      output = '' if output.nil?
      output = output.delete("\n") unless output.empty?
    end
  end
end
