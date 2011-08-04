
require 'rib'
require 'readline'

module Rib::Readline
  include Rib::Plugin

  def before_loop
    @history = ::Readline::HISTORY
    super
  end

  def get_input
    ::Readline.readline(prompt, true)
  end

  Shell.use(self)
end
