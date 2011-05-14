# coding: utf-8

module Boom
  class OS
    class << self
      # Public: tests if currently running on darwin.
      #
      # Returns true if running on darwin (MacOS X), else false
      def darwin?
        !!(RUBY_PLATFORM =~ /darwin/)
      end

      # Public: tests if currently running on windows.
      #
      # Returns true if running on windows, else false
      def windows?
        !!(RUBY_PLATFORM =~ /win|mingw/)
      end
    end
  end
end
