
module Ripl::Rc::CtrldNewline
  # make ctrl-d end with a newline
  def after_loop
    puts unless @input
    super
  end
end

Ripl::Shell.include(Ripl::Rc::CtrldNewline)
