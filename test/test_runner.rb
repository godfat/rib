
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

  def verify_app_e argv
     input('a')
    output('1')
    conf = {:name => 'rib'}
    min  = 'rib-min'
    mock(Rib::Runner).which_bin(min){ min }
    mock(Rib::Runner).load(min){ Rib::Runner.run(argv) }
    stub(Rib).config{ conf }
    Rib::Runner.run(argv).should.eq @shell
  end

  should 'min -e' do
    verify_app_e(%w[min -ea=1])
  end

  should '-e min' do
    verify_app_e(%w[-ea=1 min])
  end
end
