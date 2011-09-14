
module Rib; end
module Rib::Ramaze
  module_function
  def load
    load_ramaze
  rescue LoadError => e
    Rib.abort("Error: #{e}", "Is this a Ramaze app?")
  end

  def load_ramaze
    # try to produce consistent error message, and yet lazy loading ramaze
    require './start' unless ramaze?

    require 'ramaze'
    ::Ramaze.options.started = true

    require './start'
    at_exit{ puts('Ramazement has ended, go in peace.') }
  end

  def ramaze?
    File.exist?('./start.rb')
  end
end
