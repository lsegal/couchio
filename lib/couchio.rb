require 'rubygems'
require 'json'
require 'uri'
require 'net/http'
require 'base64'

root = File.join(File.dirname(__FILE__), 'couchio')

['couch_io', 'couch_open', 'couch_database', 'couch_document'].each do |f|
  require File.join(root, f)
end

Dir[root + '/core_ext/*.rb'].each {|f| require f }