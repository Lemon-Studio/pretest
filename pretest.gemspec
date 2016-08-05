# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pretest/version'

Gem::Specification.new do |spec|
  spec.name          = "pretest"
  spec.version       = Pretest::VERSION
  spec.authors       = ["Lucas Machado"]
  spec.email         = ["lucas.dpmachado@gmail.com"]

  spec.summary       = "Cucumber web project creator"
  spec.description   = "A gem that creates a cucumber project structure"
  spec.homepage      = "https://github.com/machado144/pretest"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://github.com/machado144/pretest"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "pretest"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'thor', '~> 0'
end
