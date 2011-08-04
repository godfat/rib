
require 'rib'
require 'readline'

module Rib::Readline
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    @history = ::Readline::HISTORY
    super
  end

  def get_input
    ::Readline.readline(prompt, true)
  end
end
