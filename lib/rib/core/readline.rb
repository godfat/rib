
require 'rib'
require 'readline'

module Rib::Readline
  include Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if Readline.disabled?
    config[:history] = ::Readline::HISTORY
    super
  end

  def get_input
    return super if Readline.disabled?
    ::Readline.readline(prompt, true)
  end
end
