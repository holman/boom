module Boom
  module Output
    # Public: prints any given string.
    #
    # s = String output
    #
    # Prints to STDOUT and returns. This method exists to standardize output
    # and for easy mocking or overriding.
    def output(s)
      puts(s)
    end
  end
end
