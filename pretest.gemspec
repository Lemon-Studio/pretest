# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pretest/version'

Gem::Specification.new do |spec|
  spec.name          = 'pretest'
  spec.version       = Pretest::VERSION
  spec.authors       = ['Lucas Machado', 'Murilo Machado']
  spec.email         = ['lucas.dpmachado@gmail.com', 'murilo.paula.machado@gmail.com']

  spec.summary       = 'Cucumber web, desktop and mobile project creator'
  spec.description   = 'A gem that creates a cucumber project structure'
  spec.homepage      = 'https://github.com/VilasBoasIT/pretest'
  spec.license       = 'GNU AGPL3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = 'pretest'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14', '>= 1.14.6'
  spec.add_development_dependency 'rake', '~> 12.0', '>= 12.0.0'
  spec.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'

  spec.add_runtime_dependency 'thor', '~> 0'
  spec.add_runtime_dependency 'bundler', '~> 0'
  spec.add_runtime_dependency 'rubyzip', '~> 1.2', '>= 1.2.1'
  spec.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
  spec.add_runtime_dependency 'pry', '~> 0.10.4'
end
