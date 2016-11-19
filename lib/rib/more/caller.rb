
require 'rib'

module Rib::Caller
  extend Rib::Plugin
  Shell.use(self)

  module Imp
    def caller
      return if Rib::Caller.disabled?

      backtrace = Rib.shell.format_backtrace(super.drop(1))

      lib = %r{\brib-#{Rib::VERSION}/lib/rib/}
      if backtrace.first =~ lib
        backtrace.shift while backtrace.first =~ lib
      elsif backtrace.last =~ lib
        backtrace.pop while backtrace.last =~ lib
      end

      puts backtrace.map{ |l| "  #{l}" }

      Rib::Skip
    end
  end

  Rib.extend(Imp)
end
