
require 'ripl/rc/u'

module Ripl::Rc::History
  include Ripl::Rc::U

  # avoid some complicated conditions...
  def history
    super || (@history ||= [])
  end

  # avoid double initialization for history
  def before_loop
    return super if SqueezeHistory.disabled?
    super if history.empty?
  end
end

Ripl::Shell.include(Ripl::Rc::History)
