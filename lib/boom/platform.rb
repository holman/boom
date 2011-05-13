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

      # Public: returns the command used to open a file or URL
      # for the current platform.
      #
      # Returns a String with the bin
      def open_command
        if OS.darwin?
          'open'
        elsif OS.windows?
          'start'
        else
          'xdg-open'
        end
      end

      # Public: opens a given Item's value in the browser. This
      # method is designed to handle multiple platforms.
      #
      # Returns a String explaining what was done
      def open(item)
        unless OS.windows?
          system("#{open_command} '#{item.url.gsub("\'","\\'")}'")
        else
          system("#{open_command} #{item.url.gsub("\'","\\'")}")
        end

        "#{cyan("Boom!")} We just opened #{yellow(item.value)} for you."
      end

      # Public: returns the command used to copy a given Item's value to the
      # clipboard for the current platform.
      #
      # Returns a String with the bin
      def copy_command
        if OS.darwin?
          'pbcopy'
        elsif OS.windows?
          'clip'
        else
          'xclip -selection clipboard'
        end
      end
      
      # Public: copies a given Item's value to the clipboard. This method is
      # designed to handle multiple platforms.
      #
      # Returns a String explaining what was done
      def copy(item)
        unless OS.windows?
          system("printf '#{item.value.gsub("\'","\\'")}' | #{copy_command}")
        else
          system("echo #{item.value.gsub("\'","\\'")} | #{copy_command}")
        end

        "#{cyan("Boom!")} We just copied #{yellow(item.value)} to your clipboard."
      end

      # Public: opens the JSON file in an editor for you to edit. Uses the
      # $EDITOR environment variable, or %EDITOR% on Windows for editing.
      # This method is designed to handle multiple platforms.
      #
      # Returns a String explaining what was done
      def edit(json_file)
        unless OS.windows?
          system("`echo $EDITOR` #{json_file} &")
        else
          system("start %EDITOR% #{json_file}")
        end

        "#{cyan("Boom!")} Make your edits, and do be sure to save."
      end
    end
  end
end
