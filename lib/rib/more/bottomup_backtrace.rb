# frozen_string_literal: true

require 'rib'

module Rib; module BottomupBacktrace
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def format_error err
    return super if BottomupBacktrace.disabled?
    message, backtrace = get_error(err)
    "  #{backtrace.join("\n  ")}\n#{message}"
  end

  def format_backtrace backtrace
    super(backtrace).reverse
  end
end; end
