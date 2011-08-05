
require 'rib/test'
require 'rib/core/underscore'

describe Rib::Underscore do
  behaves_like :rib

  before do
    Rib::Underscore.enable
  end

  def setup bound=Object.new
    @shell = Rib::Shell.new(
      :binding => bound.instance_eval{binding}).before_loop
  end

  should 'set _' do
    setup
    @shell.eval_input('_').should.equal nil
    @shell.eval_input('10 ** 2')
    @shell.eval_input('_').should.equal 100
  end

  should 'not set _ if already there' do
    bound = Object.new
    def bound._
      'hey'
    end
    setup(bound)
    @shell.eval_input('_').should.equal 'hey'
    @shell.eval_input('10 ** 2')
    @shell.eval_input('_').should.equal 'hey'
  end

  should 'set __' do
    setup
    stub(@shell).warn
    @shell.eval_input('XD')
    @shell.eval_input('__').should.kind_of?(NameError)
  end
end
