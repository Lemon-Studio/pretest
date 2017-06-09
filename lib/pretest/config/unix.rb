require 'rest-client'
require 'open-uri'
require 'fileutils'
require 'open3'
require 'pry'

module Unix
  # # This is going to be a new feature.
  # def clean_duplicated_environment_values
  #   duplicated_values = "\n\n" \
  #                       "#Clean duplicated Path\n" +
  #                       "PATH=$(echo '$PATH' | awk -v RS=%:% -v ORS=':' %!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}%)".tr!("'", '"').tr!('%', "'")
  # end

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
