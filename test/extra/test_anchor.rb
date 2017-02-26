
require 'rib/test'
require 'rib/more/anchor'
require 'rib/core/multiline'
require 'rib/test/multiline'

describe Rib::Anchor do
  paste :rib
  paste :setup_multiline

  def new_shell
    Rib::Shell.new(:binding => Class.new).before_loop
  end

  test_for Rib::Anchor, Rib::Multiline do
    paste :multiline
  end
end
