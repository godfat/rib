
require 'rib/test'
require 'rib/test/multiline'
require 'rib/more/multiline'

shared :multiline_check do
  def check str
    lines = str.split("\n")
    lines[0...-1].each{ |line|
      input(line)
      @shell.loop_once
    }
    input_done(lines.last)
  end
  behaves_like :multiline
end

describe Rib::Multiline do
  behaves_like :rib
  behaves_like :setup_multiline

  Rib.disable_plugins
  Rib::Multiline.enable
  behaves_like :multiline_check

  Rib.plugins.each{ |plugin|
    Rib.disable_plugins
    Rib::Multiline.enable
    plugin.enable
    behaves_like :multiline_check
  }
end
