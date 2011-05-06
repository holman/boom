# coding: utf-8

# Platform is a centralized point to shell out platform specific functionality
# like clipboard access or commands to open URLs.
#
#
# Clipboard is a centralized point to shell out to each individual platform's
# clipboard, pasteboard, or whatever they decide to call it.
#
module Boom
  class Platform
    class << self
      include Boom::Color

      # Public: tests if currently running on darwin.
      #
      # Returns true if running on darwin (MacOS X), else false
      def darwin?
        !!(RUBY_PLATFORM =~ /darwin/)
      end

      # Public: returns the command used to open a file or URL
      # for the current platform.
      #
      # Currently only supports MacOS X and Linux with `xdg-open`.
      #
      # Returns a String with the bin
      def open_command
        darwin? ? 'open' : 'xdg-open'
      end

      # Public: opens a given Item's value in the browser. This
      # method is designed to handle multiple platforms.
      #
      # Returns a String explaining what was done
      def open(item)
        `#{open_command} '#{item.url.gsub("\'","\\'")}'`

        "#{cyan("Boom!")} We just opened \"#{yellow(item.value)}\" for you."
      end

      # Public: copies a given Item's value to the clipboard. This method is
      # designed to handle multiple platforms.
      #
      # Returns a String explaining what was done
      def copy(item)
        copy_command = darwin? ? "pbcopy" : "xclip -selection clipboard"

        Kernel.system("printf '#{item.value.gsub("\'","\\'")}' | #{copy_command}")

        "#{cyan("Boom!")} We just copied \"#{yellow(item.value)}\" to your clipboard."
      end
    end
  end
end
