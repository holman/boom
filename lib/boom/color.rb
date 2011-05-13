# coding: utf-8

module Boom
  # Color collects some methods for colorizing terminal output.
  module Color
    extend self

    CODES = {
      :reset   => "\e[0m",

      :cyan    => "\e[36m",
      :magenta => "\e[35m",
      :red     => "\e[31m",
      :yellow  => "\e[33m"
    }

    # Tries to enable Windows support if on that platform.
    #
    # Returns nothing.
    def self.included(other)
      require 'Win32/Console/ANSI' if OS.windows?
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
    #   colorize("Boom!", :magenta)
    #   # => "\e[35mBoom!\e[0m"
    #
    # Returns the wrapped String.
    def colorize(string, color_code)
      "#{CODES[color_code] || color_code}#{string}#{CODES[:reset]}"
    end

    # Set up shortcut methods to all the codes defined in CODES.
    self.class_eval(CODES.keys.reject {|color| color == :reset }.map do |color|
      "def #{color}(string); colorize(string, :#{color}); end"
    end.join("\n"))
  end
end
