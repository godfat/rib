
require 'rib/test'
require 'rib/runner'

describe Rib::Runner do
  paste :rib

  before do
    mock(Rib).shell{ shell }.times(2)
  end

  def input *args
    args.each{ |item| mock(shell).get_input{ item } }
    mock(shell).get_input{}
  end

  def output *args
    args.each{ |item| mock(shell).puts("=> #{item}"){} }
    mock(shell).puts{}
  end

  would '-e' do
     input('a')
    output('1')

    expect(Rib::Runner.run(%w[-ea=1])).eq shell
  end

  would '-e nothing' do
     input
    output

    expect(Rib::Runner.run(%w[-e])).eq shell
  end

  def verify_app_e argv
     input('a')
    output('1')
    conf = {:name => 'rib'}
    min  = 'rib-min'

    mock(Rib::Runner).which_bin(min){ min }
    mock(Rib::Runner).load(min){ Rib::Runner.run(argv) }
    stub(Rib).config{ conf }

    expect(Rib::Runner.run(argv)).eq shell
  end

  would 'min -e' do
    verify_app_e(%w[min -ea=1])
  end

  would '-e min' do
    verify_app_e(%w[-ea=1 min])
  end
end
