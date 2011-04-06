# coding: utf-8

module Boom

  # Color collects some methods for colorizing terminal output.
  module Color

    CODES = {
      :reset   => "\e[0m",

      :magenta => "\e[35m",
      :red     => "\e[31m",
      :yellow  => "\e[33m"
    }

    # Tries to enable Windows support if on that platform.
    #
    # Returns nothing.
    def self.included(other)
      require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
    rescue LoadError
      # Oh well, we tried.
    end

    # Wraps the given string in ANSI color codes
    #
    # string     - The String to wrap.
    # color_code - The String representing he ANSI color code
    #
    # Examples
    #
    #   colorize("Boom!", "\e[33m")
    #   # => "\e[33mBoom!\e[0m"
    #
    # Returns the wrapped String.
    def colorize(string, color_code)
      "#{color_code}#{string}#{CODES[:reset]}"
    end

    # Set up shortcut methods to all the codes define in CODES.
    self.class_eval(CODES.reject {|color, code| color == :reset }.map do |color, code|
      "def #{color}(string); colorize(string, \"#{code}\"); end"
    end.join("\n"))
  end
end
