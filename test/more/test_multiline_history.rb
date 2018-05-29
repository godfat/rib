
require 'rib/test'
require 'rib/test/multiline'
require 'rib/more/multiline_history'

describe Rib::MultilineHistory do
  paste :rib
  paste :setup_multiline

  def check str, err=nil
    shell.history.clear
    with_history(str, err)

    @shell = nil
    stub_output

    shell.history.clear
    shell.history << 'old history'
    with_history(str, err, 'old history')
  end

  def with_history str, err, *prefix
    lines = str.split("\n")
    lines[0...-1].inject([]){ |result, line|
      input(line)
      shell.loop_once
      result << line

      expect(shell.history.to_a).eq prefix + result

      result
    }
    input_done(lines.last, err)

    history = if lines.size == 1
                lines.first
              else
                "\n#{lines.join("\n")}"
              end

    expect(shell.history.to_a).eq prefix + [history]
  end

  test_for Rib::History, Rib::Multiline, Rib::MultilineHistory do
    paste :multiline
  end
end
