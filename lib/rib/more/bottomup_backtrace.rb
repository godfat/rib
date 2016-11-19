
require 'rib'

module Rib::BottomupBacktrace
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def format_error err
    return super if BottomupBacktrace.disabled?
    message, backtrace = get_error(err)
    "  #{format_backtrace(backtrace).join("\n  ")}\n#{message}"
  end

  def format_backtrace backtrace
    super(backtrace).reverse
  end
end
