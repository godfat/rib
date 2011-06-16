
require 'ripl/rc/u'

module Ripl::Rc::EnsureAfterLoop
  include Ripl::Rc::U

  def in_loop
    return super if EnsureAfterLoop.disabled?
    begin
      super
    rescue Exception
      after_loop
      raise
    end
  end
end

Ripl::Shell.include(Ripl::Rc::EnsureAfterLoop)
