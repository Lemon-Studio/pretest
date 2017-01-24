$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pretest'
require 'yaml'

CONFIG_DATA = YAML.load_file('./spec/data/data.yml')
