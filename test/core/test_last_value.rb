
require 'rib/test'
require 'rib/core/last_value'

copy :last_value do
  would 'set last_value' do
    mock(shell).get_input{'Rib.last_value'}
    mock(shell).get_input{'10**2'}
    mock(shell).get_input{'Rib.last_value'}

    shell.loop_once.should.eq [nil, nil]
    shell.loop_once
    shell.loop_once.should.eq [100, nil]
  end

  would 'set last_exception' do
    stub(shell).puts{}.with_any_args
    mock(shell).get_input{'XD'}
    mock(shell).get_input{'Rib.last_exception'}

    shell.loop_once
    shell.loop_once.first.should.kind_of?(NameError)
  end
end

describe Rib::LastValue do
  paste :rib

  before do
    stub(shell).puts(is_a(String)){}
    stub(Rib).shell{ shell }
  end

  test_for Rib::LastValue do
    paste :last_value
  end
end
