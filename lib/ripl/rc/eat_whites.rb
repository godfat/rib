
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::EatWhites
  # don't print empty input
  def print_result result
    super unless @input.strip == ''
  end
end

Ripl::Shell.include(Ripl::Rc::EatWhites)
