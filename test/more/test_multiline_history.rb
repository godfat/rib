
require 'rib/test'
require 'rib/test/multiline'
require 'rib/more/multiline_history'

describe Rib::MultilineHistory do
  behaves_like :rib
  behaves_like :setup_multiline

  def check str, err=nil
    @shell.history.clear
    with_history(str, err)

    setup_shell

    @shell.history.clear
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
    @shell.history.to_a.should.eq prefix + ["\n#{lines.join("\n")}"]
  end

  for_each_plugin do
    Rib::History.enable
    Rib::Multiline.enable
    Rib::MultilineHistory.enable
    behaves_like :multiline
  end
end
