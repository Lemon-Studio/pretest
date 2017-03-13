require 'rest-client'
require 'open-uri'
require 'fileutils'

module Unix
  def check_gecko_environment_variables
    set_gecko_env_variables
    File.new("#{ENV['HOME']}/.pretest", 'w') unless Dir.entries(ENV['HOME']).include?('.pretest')
    if File.read("#{ENV['HOME']}/.pretest").include?('GECKO_DRIVER')
      puts 'GeckoDriver Home is already defined'
      File.open("#{ENV['HOME']}/.bash_profile", 'a') { |file| file << @set_source } unless File.read("#{ENV['HOME']}/.bash_profile").include?('.pretest')
    else
      File.open("#{ENV['HOME']}/.pretest", 'a') { |file| file << @gecko_driver }
      File.open("#{ENV['HOME']}/.bash_profile", 'a') { |file| file << @set_source }
      system 'source ~/.bash_profile'
      puts 'GeckoDriver defined with success'
    end
  end

  def set_gecko_env_variables
    @gecko_driver = "\n\n# Set Gecko Driver Path
export GECKO_DRIVER='/usr/local/share'
export PATH='${PATH}:${GECKO_DRIVER}/geckodriver'
export PATH='${PATH}:${GECKO_DRIVER}'".tr!("'", '"')
    @set_source = "\n[[ -s '$HOME/.pretest'  ]] && source '$HOME/.pretest' # Load environment variables defined in pretest".tr!("'", '"')
  end
end
