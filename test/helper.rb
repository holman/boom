require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
rescue LoadError
end

require 'mocha'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'boom'

# test/spec/mini 3
# http://gist.github.com/25455
# chris@ozmm.org
# file:lib/test/spec/mini.rb
def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(defined?(ActiveSupport::TestCase) ? ActiveSupport::TestCase : Test::Unit::TestCase) do
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.setup(&block) define_method(:setup, &block) end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval &block
end
