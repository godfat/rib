# frozen_string_literal: true

require 'rib'

module Rib; module StripBacktrace
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def format_error err
    return super if StripBacktrace.disabled?
    message, backtrace = get_error(err)
    "#{message}\n  #{backtrace.join("\n  ")}"
  end

  def get_error err
    return super if StripBacktrace.disabled?
    ["#{err.class}: #{err.message}", format_backtrace(err.backtrace)]
  end

  module_function
  def format_backtrace backtrace
    return super if StripBacktrace.disabled?
    strip_home_backtrace(
      strip_cwd_backtrace(
        strip_rib_backtrace(super(backtrace))))
  end

  def strip_home_backtrace backtrace
    backtrace.map(&method(:replace_path_prefix).curry[ENV['HOME'], '~/'])
  end

  def strip_cwd_backtrace backtrace
    backtrace.map(&method(:replace_path_prefix).curry[Dir.pwd, ''])
  end

  def strip_rib_backtrace backtrace
    backtrace[
      0..backtrace.rindex{ |l| l =~ /\(#{name}\):\d+:in `.+?'/ } || -1]
  end

  def replace_path_prefix prefix, substitute, path
    path.sub(/\A#{Regexp.escape(prefix)}\//, substitute)
  end
end; end
