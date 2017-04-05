require 'rest-client'
require 'open-uri'
require 'fileutils'

module Unix
  def check_gecko_environment_variables
    set_gecko_env_variables
    File.open("#{ENV['HOME']}/.bashrc", 'w') {} unless Dir.entries(ENV['HOME']).to_s.include?('bashrc')
    File.open("#{ENV['HOME']}/.pretest", 'w') {} unless Dir.entries(ENV['HOME']).to_s.include?('pretest')
    bashrc = File.read("#{ENV['HOME']}/.bashrc")
    pretest = File.read("#{ENV['HOME']}/.pretest")
    if pretest.include?('GECKO_DRIVER') || pretest.include?("'/usr/local/share'")
      puts 'GeckoDriver Home is already defined'
      File.open("#{ENV['HOME']}/.bashrc", 'a') { |file| file << @set_source } unless bashrc.include?('.pretest')
    else
      File.open("#{ENV['HOME']}/.pretest", 'a') { |file| file << @gecko_driver }
      File.open("#{ENV['HOME']}/.bashrc", 'a') { |file| file << @set_source }
      system 'source ~/.bashrc'
      puts 'GeckoDriver defined with success'
    end
  end

  def set_gecko_env_variables
    @gecko_driver = "\n\n# Set Gecko Driver Path
export GECKO_DRIVER='/usr/local/share'
export PATH='${PATH}:${GECKO_DRIVER}/geckodriver'
export PATH='${PATH}:${GECKO_DRIVER}'".tr!("'", '"')
    duplicated_values = "\n\n
#Clean duplicated Path
PATH=$(echo '$PATH' | awk -v RS=%:% -v ORS=':' %!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}%)".tr!("'", '"').tr!('%', "'")
    @gecko_driver = (@gecko_driver + duplicated_values)
    @set_source = "\n[[ -s '$HOME/.pretest'  ]] && source '$HOME/.pretest' # Load environment variables defined in pretest".tr!("'", '"')
  end
end
