
require 'rib'

module Rib; module Caller
  extend Plugin
  Shell.use(self)

  module Imp
    def caller *filters
      return if Rib::Caller.disabled?

      backtrace = Rib.shell.format_backtrace(super().drop(1))

      lib = %r{\brib-#{Rib::VERSION}/lib/rib/}
      if backtrace.first =~ lib
        backtrace.shift while backtrace.first =~ lib
      elsif backtrace.last =~ lib
        backtrace.pop while backtrace.last =~ lib
      end

      result = filters.map do |f|
        case f
        when Regexp
          f
        when String
          %r{\bgems/#{Regexp.escape(f)}\-[\d\.]+/lib/}
        end
      end.inject(backtrace, &:grep_v)

      Rib.shell.puts result.map{ |l| "  #{l}" }.join("\n")

      Rib::Skip
    end
  end

  Rib.extend(Imp)
end; end
