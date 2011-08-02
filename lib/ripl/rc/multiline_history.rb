
require 'ripl/rc/u'
require 'ripl/rc/multiline' # dependency

module Ripl::Rc::MultilineHistory
  include Ripl::Rc::U

  def loop_eval(input)
    return super if MultilineHistory.disabled?
    super # might throw
  ensure
    unless @rc_multiline_buffer.empty?
      (@rc_multiline_buffer.size + (@rc_multiline_trash || 0)).
        times{ history.pop }
       @rc_multiline_trash = 0
      history << "\n" + @rc_multiline_buffer.join("\n")
    end
  end

  def handle_interrupt
    return super if MultilineHistory.disabled?
    unless @rc_multiline_buffer.empty?
      @rc_multiline_trash ||= 0
      @rc_multiline_trash  += 1
    end
    super
  end
end

Ripl::Shell.include(Ripl::Rc::MultilineHistory)
