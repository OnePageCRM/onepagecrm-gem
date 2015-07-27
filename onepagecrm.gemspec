# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onepagecrm/version'
require 'pry'
Gem::Specification.new do |spec|
  spec.name          = 'onepagecrm'
  spec.version       = OnePageCRM::VERSION
  spec.authors       = ['Peter Armstrong']
  spec.email         = ['devteam@onepagecrm.com']
  spec.summary       = 'Basic Gem for OnePageCRM'
  spec.description   = 'Basic Gem for the OnePageCRM API'
  spec.homepage      = 'http://developer.onepagecrm.com'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
