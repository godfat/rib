
require 'rib/test'
require 'rib/core/last_value'

describe Rib::LastValue do
  paste :rib

  before do
    stub_output
    stub(Rib).shell{shell}
  end

  test_for Rib::LastValue do
    would 'set last_value' do
      mock(shell).get_input{'Rib.last_value'}
      mock(shell).get_input{'10**2'}
      mock(shell).get_input{'Rib.last_value'}

      expect(shell.loop_once).eq [nil, nil]

      shell.loop_once

      expect(shell.loop_once).eq [100, nil]
    end

    would 'set last_exception' do
      mock(shell).get_input{'XD'}
      mock(shell).get_input{'Rib.last_exception'}

      shell.loop_once

      expect(shell.loop_once.first).kind_of?(NameError)
    end
  end
end
