
require 'rib/test'
require 'rib/test/multiline'
require 'rib/more/multiline'

describe Rib::Multiline do
  behaves_like :rib
  behaves_like :setup_multiline

  def test str
    lines = str.split("\n")
    lines[0...-1].each{ |line|
      input(line)
      @shell.loop_once
    }
    input_done(lines.last)
  end

  behaves_like :multiline
end
