module Boom
  class Runner
    def initialize(storage,*args)
      Commands.execute(storage,args) # if Commands.respond_to?(cmd)
    end
  end
end
