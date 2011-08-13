
require 'rib/core/history'   # dependency
require 'rib/core/multiline' # dependency

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
    super
  ensure
    # SyntaxError might mean we're multiline editing
    handle_multiline unless multiline?($!)
  end

  def handle_interrupt
    return super if MultilineHistory.disabled?
    if multiline_buffer.size > 1
      @multiline_trash ||= 0
      @multiline_trash  += 1
    end
    super
  end



  private
  def handle_multiline
    if multiline_buffer.size > 1
      # so multiline editing is considering done here
      (multiline_buffer.size + @multiline_trash).times{ history.pop }
      history << "\n" + multiline_buffer.join("\n")
    end
  end
end
