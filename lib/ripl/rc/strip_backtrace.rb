
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::StripBacktrace
  include Ripl::Rc # makes U avaliable

  # strip backtrace until ripl
  def format_error e
    "#{e.class}: #{e.message}\n  #{U.strip_backtrace(e).join("\n  ")}"
  end

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
end

module Ripl::Rc::U; extend Ripl::Rc::StripBacktrace::Imp; end

Ripl::Shell.include(Ripl::Rc::StripBacktrace)
