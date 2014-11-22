# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onepagecrm/version'

Gem::Specification.new do |spec|
  spec.name          = 'onepagecrm'
  spec.version       = Onepagecrm::VERSION
  spec.authors       = ['Peter Armstrong']
  spec.email         = ['peter@onepagecrm.com']
  spec.summary       = %q{Basic Gem for OnePageCRM.}
  spec.description   = %q{Basic Gem for OnePageCRM.}
  spec.homepage      = 'developer.onepagecrm.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'json_spec'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'pry'
end
