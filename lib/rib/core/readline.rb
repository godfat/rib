
require 'rib'
require 'readline'

module Rib; module Readline
  extend Plugin
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

unless ::Readline::HISTORY.respond_to?(:last)
  def (::Readline::HISTORY).last
    self[-1]
  end
end; end
