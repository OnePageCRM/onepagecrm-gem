require 'yaml'
require 'codeclimate-test-reporter'
TEST_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/../config/config.yml")

ENV['CODECLIMATE_REPO_TOKEN'] = TEST_CONFIG['codeclimate_key']
CodeClimate::TestReporter.start
require 'onepagecrm'
