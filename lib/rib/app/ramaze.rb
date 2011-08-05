
module Rib; end
module Rib::Ramaze
  module_function
  def load
    load_ramaze
  rescue LoadError => e
    Rib.abort("Is this a Ramaze app?\n  #{e}")
  end

  def load_ramaze
    # try to produce consistent error message, and yet lazy loading ramaze
    require './start' unless File.exist?('./start.rb')

    require 'ramaze'
    ::Ramaze.options.started = true

    require './start'
    at_exit{ puts('Ramazement has ended, go in peace.') }
  end
end
