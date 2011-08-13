
require 'rib/test'
require 'rib/test/multiline'
require 'rib/core/multiline'

describe Rib::Multiline do
  behaves_like :rib
  behaves_like :setup_multiline

  def check str, err=nil
    lines = str.split("\n")
    lines[0...-1].each{ |line|
      input(line)
      @shell.loop_once
    }
    input_done(lines.last, err)
  end

  test_for Rib::Multiline do
    behaves_like :multiline
  end
end
