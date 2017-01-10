
require 'rib/test'
require 'rib/more/caller'

describe Rib::Caller do
  paste :rib

  test_for Rib::Caller do
    would 'puts some backtrace' do
      mock(Rib.shell).puts(is_a(String)){ ok }

      Rib.caller
    end
  end
end
