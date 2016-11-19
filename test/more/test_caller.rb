
require 'rib/test'
require 'rib/more/caller'

describe Rib::Caller do
  paste :rib

  test_for Rib::Caller do
    would 'puts some backtrace' do
      mock(Rib).puts(is_a(Array)){ ok }

      Rib.caller
    end
  end
end
