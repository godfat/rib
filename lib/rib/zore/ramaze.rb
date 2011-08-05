
require 'rib'

module Rib::Ramaze
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    load_ramaze
    super
  end

  def after_loop
    puts('Ramazement has ended, go in peace.')
    super
  end

  module_function
  def load_ramaze
    require 'ramaze'
    ::Ramaze.options.started = true
    require './start'
  end
end
