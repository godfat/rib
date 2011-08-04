
require 'rib'

module Rib::StripBacktrace
  include Rib::Plugin
  Shell.use(self)

  # strip backtrace until ripl
  def format_error e
    return super if StripBacktrace.disabled?
    message, backtrace = get_error(e, P.strip_backtrace(e, config[:name]))
    "#{message}\n  #{backtrace.join("\n  ")}"
  end

  def get_error e, backtrace=e.backtrace
    return super if StripBacktrace.disabled?
    ["#{e.class}: #{e.message}", backtrace]
  end

  private
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

  Plugin.extend(Imp)
end
