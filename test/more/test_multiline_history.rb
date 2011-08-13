
require 'rib/test'
require 'rib/test/multiline'
require 'rib/more/multiline_history'

describe Rib::MultilineHistory do
  behaves_like :rib
  behaves_like :setup_multiline

  def check str, err=nil
    clear_history(@shell.history)
    with_history(str, err)

    setup_shell

    clear_history(@shell.history)
    @shell.history << 'old history'
    with_history(str, err, 'old history')
  end

  def with_history str, err, *prefix
    lines = str.split("\n")
    lines[0...-1].inject([]){ |result, line|
      input(line)
      @shell.loop_once
      result << line
      @shell.history.to_a.should.eq prefix + result
      result
    }
    input_done(lines.last, err)
    history = if lines.size == 1
                lines.first
              else
                "\n#{lines.join("\n")}"
              end
    @shell.history.to_a.should.eq prefix + [history]
  end

  test_for Rib::History, Rib::Multiline, Rib::MultilineHistory do
    behaves_like :multiline
  end
end
