
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::StripBacktrace
  include Ripl::Rc # makes U avaliable

  # strip backtrace until ripl
  def format_error e
    klass, message, backtrace = get_error(e, U.strip_backtrace(e, @name))
    "#{klass}: #{message}\n  #{backtrace.join("\n  ")}"
  end

  def get_error e, backtrace=e.backtrace
    [e.class, e.message, backtrace]
  end

  module Imp
    def strip_backtrace e, name
      home(cwd(snip(e, name)))
    end

    def home b
      b.map{ |p| p.sub(ENV['HOME'], '~') }
    end

    def cwd b
      b.map{ |p| p.sub(Dir.pwd, '.') }
    end

    def snip e, name
      return [] if e.kind_of?(SyntaxError)
      e.backtrace[
        0..
        e.backtrace.rindex{ |l| l =~ /\(#{name}\):\d+:in `.+?'/ } || -1]
    end
  end
end

module Ripl::Rc::U; extend Ripl::Rc::StripBacktrace::Imp; end

Ripl::Shell.include(Ripl::Rc::StripBacktrace)
