
require 'ripl'

module Ripl::Rc
  module Imp
    module_function
    def strip_backtrace e
      home(cwd(snip(e)))
    end

    def home b
      b.map{ |p| p.sub(ENV['HOME'], '~') }
    end

    def cwd b
      b.map{ |p| p.sub(Dir.pwd, './') }
    end

    def snip e
      e.backtrace[0..e.backtrace.rindex{ |l| l =~ /\(ripl\):\d+:in `.+?'/ } ||
                     -1]
    end
  end
  module U; extend Imp; end
end

module Ripl::Rc::StripBacktrace
  include Ripl::Rc

  # strip backtrace until ripl
  def format_error e
    "#{e.class}: #{e.message}\n  #{U.strip_backtrace(e).join("\n  ")}"
  end
end

Ripl::Shell.include(Ripl::Rc::StripBacktrace)
