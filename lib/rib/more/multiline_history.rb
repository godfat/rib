
require 'rib/more/multiline' # dependency

module Rib::MultilineHistory
  include Rib::Plugin
  Shell.use(self)

  def loop_eval(input)
    return super if MultilineHistory.disabled?
    super # might throw
  ensure
    unless @multiline_buffer.empty?
      (@multiline_buffer.size + (@multiline_trash || 0)).
        times{ history.pop }
       @multiline_trash = 0
      history << "\n" + @multiline_buffer.join("\n")
    end
  end

  def handle_interrupt
    return super if MultilineHistory.disabled?
    unless @multiline_buffer.empty?
      @multiline_trash ||= 0
      @multiline_trash  += 1
    end
    super
  end
end
