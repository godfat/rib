
module Rib; end
module Rib::Ramaze
  module_function
  def load
    require 'ramaze'
    ::Ramaze.options.started = true
    require './start'
    at_exit{ puts('Ramazement has ended, go in peace.') }

  rescue LoadError => e
    abort("#{Rib.config[:name]}: Is this a Ramaze app?\n  #{e}")
  end
end

Rib.require_rc
Rib::Ramaze.load
