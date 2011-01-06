begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'yajl'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'boom/clipboard'
require 'boom/command'
require 'boom/item'
require 'boom/list'
require 'boom/storage'

module Boom
  VERSION = '0.0.6'

  def self.storage
    @storage ||= Boom::Storage.new
  end
end
