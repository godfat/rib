
require 'ripl/rc/u'

module Ripl::Rc::LastException
  include Ripl::Rc::U

  def print_eval_error(e)
    Ripl.last_exception = nil
    return super if LastException.disabled?
    Ripl.last_exception = e
    super
  end
end

class << Ripl
  attr_accessor :last_exception
end

Ripl::Shell.include(Ripl::Rc::LastException)
