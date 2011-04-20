
require 'ripl/rc/u'

module Ripl::Rc::HistoryIvar
  include Ripl::Rc::U

  def history
    return super if HistoryIvar.disabled?
    # avoid conflict on build-in @history object!
    # since it would get initialized to [] upon before_loop
    # and here nothing we can prevent it... i hope that
    # could be updated to something like @history ||= []
    # then i can set @history to other value before it gets set to []
    @history_ivar ||= super || [] # if readline is not available
  end
end

Ripl::Shell.include(Ripl::Rc::HistoryIvar)
