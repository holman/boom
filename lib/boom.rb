# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'multi_json'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'boom/color'
require 'boom/platform'
require 'boom/command'
require 'boom/config'
require 'boom/item'
require 'boom/list'
require 'boom/storage'

require 'boom/core_ext/symbol'

module Boom
  VERSION = '0.2.4'

  def self.storage
    Storage.new
  end
end