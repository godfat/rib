
require 'rib/config'
require 'rib/more/anchor'
Rib::Anchor.disable
Rib::Debugger.disable if Rib.const_defined?(:Debugger)
