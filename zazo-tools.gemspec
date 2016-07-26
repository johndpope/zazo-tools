lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'zazo/version'

Gem::Specification.new do |spec|
  spec.name          = 'zazo-tools'
  spec.version       = Zazo::VERSION
  spec.authors       = ['Ivan Kornilov']
  spec.email         = ['vano468@gmail.com']
  spec.summary       = 'Common components of Zazo'

  spec.files         = `git ls-files`.split($/).reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'rails'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'faraday-digestauth'
  spec.add_runtime_dependency 'aws-sdk'
  spec.add_runtime_dependency 'active_interaction'
end
