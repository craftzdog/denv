# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'denv/version'

Gem::Specification.new do |spec|
  spec.name          = "denv"
  spec.version       = Denv::VERSION
  spec.authors       = ["Takuya Matsuyama"]
  spec.email         = ["nora@odoruinu.net"]
  spec.summary       = "Environment Builder Using Docker for Client-side Application"
  spec.description   = "Denv helps building Docker container for testing/development of client-side application."
  spec.homepage      = "http://odoruinu.net/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "docker-api"
  spec.add_dependency "colorize"
end
