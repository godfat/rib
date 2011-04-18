
require 'ripl/rc/u'
require 'ripl/rc/multiline' # dependency

module Ripl::Rc::MultilineHistory
  include Ripl::Rc::U

  def print_eval_error(e)
    return super if MultilineHistory.disabled?
    catch(:rc_multiline_cont) do
      return super
    end
    history.pop
    throw :rc_multiline_cont
  end

  def loop_eval(input)
    return super if MultilineHistory.disabled?
    if @rc_multiline_buffer.empty?
      super
    else
      history.pop
      history << "\n" + @rc_multiline_buffer.join("\n") + "\n#{input}"
      super
    end
  end
end

Ripl::Shell.include(Ripl::Rc::MultilineHistory)
