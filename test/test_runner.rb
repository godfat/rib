
require 'rib/test'
require 'rib/runner'

describe Rib::Runner do
  behaves_like :rib

  before do
    Rib.disable_plugins
    @shell = Rib::Shell.new
    mock(Rib).shell{ @shell }.times(2)
  end

  def input *args
    args.each{ |item| mock(@shell).get_input{ item } }
    mock(@shell).get_input{}
  end

  def output *args
    args.each{ |item| mock(@shell).puts("=> #{item}"){} }
    mock(@shell).puts{}
  end

  should '-e' do
     input('a')
    output('1')
    Rib::Runner.run(%w[-ea=1]).should.eq @shell
  end

  should '-e nothing' do
     input
    output
    Rib::Runner.run(%w[-e]).should.eq @shell
  end

  should 'min -e' do
     input('a')
    output('1')
    argv = %w[min -ea=1]
    mock(Rib::Runner).which_bin('rib-min'){ 'rib-min' }
    mock(Rib::Runner).load('rib-min'){ Rib::Runner.run(argv) }
    Rib::Runner.run(argv).should.eq @shell
  end
end
