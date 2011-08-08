
require 'rib/core/history'   # dependency
require 'rib/more/multiline' # dependency

module Rib::MultilineHistory
  include Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    @multiline_trash = 0
    super
  end

  def loop_eval input
    return super if MultilineHistory.disabled?
    value = super
  rescue Exception
    # might be multiline editing, ignore
    raise
  else
    if multiline_buffer.size > 1
      # so multiline editing is considering done here
      (multiline_buffer.size + @multiline_trash).times{ history.pop }
      history << "\n" + multiline_buffer.join("\n")
    end
    value
  end

  def handle_interrupt
    return super if MultilineHistory.disabled?
    if multiline_buffer.size > 1
      @multiline_trash ||= 0
      @multiline_trash  += 1
    end
    super
  end
end
