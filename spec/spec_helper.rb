$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'vcr'
require 'timecop'
require 'aws-sdk'

Dir[File.dirname(__FILE__) + '/support/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../lib/**/*.rb'].each {|file| require file }
