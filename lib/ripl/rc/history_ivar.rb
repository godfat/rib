
require 'ripl/rc/u'

module Ripl::Rc::HistoryIvar
  include Ripl::Rc::U

  def history
    return super if HistoryIvar.disabled?
    @history ||= super || [] # if readline is not available
  end
end

Ripl::Shell.include(Ripl::Rc::HistoryIvar)
