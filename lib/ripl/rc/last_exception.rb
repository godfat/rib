
require 'ripl/rc/u'

module Ripl::Rc::LastException
  include Ripl::Rc::U

  def print_eval_error(e)
    Ripl.config[:rc_last_exception] = nil
    return super if LastException.disabled?
    Ripl.config[:rc_last_exception] = e
    super
  end

  module LastExceptionImp
    def last_exception
      Ripl.config[:rc_last_exception]
    end
  end
end

Ripl::Shell.include(Ripl::Rc::LastException)
# define Ripl.last_exception
Ripl    .extend(Ripl::Rc::LastException::LastExceptionImp)
Ripl::Rc.extend(Ripl::Rc::LastException::LastExceptionImp)
