
require 'rib'

module Rib::StripBacktrace
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  # strip backtrace until rib
  def format_error err
    return super if StripBacktrace.disabled?
    message, backtrace = get_error(err, strip_backtrace(err))
    "#{message}\n  #{backtrace.join("\n  ")}"
  end

  # --------------- Plugin API ---------------

  def get_error err, backtrace=err.backtrace
    return super if StripBacktrace.disabled?
    ["#{err.class}: #{err.message}", backtrace]
  end



  private
  def strip_backtrace err
    strip_home_backtrace(strip_cwd_backtrace(strip_lib_backtrace(err)))
  end

  def strip_home_backtrace backtrace
    backtrace.map{ |path| path.sub(ENV['HOME'], '~') }
  end

  def strip_cwd_backtrace backtrace
    backtrace.map{ |path| path.sub(Dir.pwd, '.') }
  end

  def strip_lib_backtrace err
    return [] if err.kind_of?(SyntaxError)
    err.backtrace[
      0..
      err.backtrace.rindex{ |l| l =~ /\(#{name}\):\d+:in `.+?'/ } || -1]
  end
end
