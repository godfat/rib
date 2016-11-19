
require 'rib'

module Rib::Caller
  extend Rib::Plugin
  Shell.use(self)

  module Imp
    def caller
      return if Rib::Caller.disabled?

      puts Rib.shell.format_backtrace(super)

      Rib::Skip
    end
  end

  Rib.extend(Imp)
end
