
require 'rib/test'
require 'rib/shell'

describe Rib::Shell do
  behaves_like :rib

  before do
    @shell = Rib::Shell.new
  end

  describe '#loop' do
    def input str
      mock(@shell).get_input{str}
      @shell.loop.should.eq @shell
    end
    should 'exit'   do                    input('exit') end
    should 'quit'   do                    input('quit') end
    should 'ctrl+d' do mock(@shell).puts; input(nil)    end
  end

  describe '#loop_once' do
    def input str=nil
      if block_given?
        mock(@shell).get_input{ yield }
      else
        mock(@shell).get_input{ str }
      end
      @shell.loop_once.should.eq nil
    end

    should 'handles ctrl+c' do
      mock(@shell).handle_interrupt
      input{ raise Interrupt }
    end

    should 'prints result' do
      mock(@shell).puts('=> "mm"')
      input('"m" * 2')
    end

    should 'error in print_result' do
      mock(@shell).warn(/rib: Error while printing result.*BOOM/m)
      input('obj = Object.new; def obj.inspect; raise "BOOM"; end; obj')
    end

    should 'print error from eval' do
      mock(@shell).warn(/RuntimeError/)
      input('raise "blah"')
    end
  end

  describe '#prompt' do
    should 'be changeable' do
      @shell.config[:prompt] = '> '
      @shell.prompt.should.eq  '> '
    end
  end

  describe '#eval_input' do
    before do
      @line = @shell.config[:line]
    end

    should 'line' do
      @shell.eval_input('10 ** 2')
      @shell.config[:line].should.eq @line + 1
    end

    should 'print error and increments line' do
      mock(@shell).warn(/^SyntaxError:/)
      @shell.eval_input('{').should.eq nil
      @shell.config[:line]  .should.eq @line + 1
    end
  end
end
