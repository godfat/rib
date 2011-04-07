
require 'ripl/rc/u'

module Ripl::Rc::CtrldNewline
  include Ripl::Rc::U

  # make ctrl-d end with a newline
  def after_loop
    return super if CtrldNewline.disabled?
    puts unless @input
    super
  end
end

Ripl::Shell.include(Ripl::Rc::CtrldNewline)
