
require 'rib'
require 'readline'

module Rib::Readline
  include Rib::Plugin

  def get_input
    ::Readline.readline(prompt, true)
  end

  def before_loop
    @history = ::Readline::HISTORY
    super
  end

  Shell.use(self)
end
