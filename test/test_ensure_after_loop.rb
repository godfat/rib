
require 'ripl/rc/test'
require 'ripl/rc/ensure_after_loop'

describe Ripl::Rc::EnsureAfterLoop do
  after do; RR.verify; end

  should 'call after_loop even if in_loop raises' do
    @shell = Ripl.shell
    mock(@shell).loop_once{ raise 'boom' }
    mock(@shell).after_loop
    lambda{ @shell.loop }.should.raise(RuntimeError)
  end
end
