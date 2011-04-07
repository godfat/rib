
require 'ripl/rc/u'

module Ripl::Rc::EatWhites
  include Ripl::Rc::U

  # don't print empty input
  def print_result result
    return super if EatWhites.disabled?
    super unless @input.strip == ''
  end
end

Ripl::Shell.include(Ripl::Rc::EatWhites)
