
require 'rib/test'
require 'rib/test/multiline'
require 'rib/core/multiline'

describe Rib::Multiline do
  paste :rib
  paste :setup_multiline

  def check str, err=nil
    lines = str.split("\n")
    lines[0...-1].each{ |line|
      input(line)
      @shell.loop_once
    }
    input_done(lines.last, err)
  end

  test_for Rib::Multiline do
    paste :multiline
  end
end
