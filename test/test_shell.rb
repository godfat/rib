
require 'rib/test'
require 'rib/shell'

describe Rib::Shell do
  behaves_like :rib

  before do
    Rib.disable_plugins
    @shell = Rib::Shell.new
  end

  describe '#loop' do
    def input str
      mock(@shell).get_input{str}
      @shell.loop
      true.should.eq true
    end
    should 'exit'      do                               input('exit' ) end
    should 'also exit' do                               input(' exit') end
    should 'ctrl+d'    do mock(@shell).puts           ; input(nil)     end
    should ':q'        do @shell.config[:exit] << ':q'; input(':q')    end
    should '\q'        do @shell.config[:exit] << '\q'; input('\q')    end
  end

  describe '#loop_once' do
    def input str=nil
      if block_given?
        mock(@shell).get_input{ yield }
      else
        mock(@shell).get_input{ str }
      end
      @shell.loop_once
      true.should.eq true
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
      mock(Rib).warn(/Error while printing result.*BOOM/m)
      input('obj = Object.new; def obj.inspect; raise "BOOM"; end; obj')
    end

    should 'not crash if user input is a blackhole' do
      mock(Rib).warn(/Error while printing result/)
      input('Rib::Blackhole')
    end

    should 'print error from eval' do
      mock(@shell).puts(/RuntimeError/)
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
      result, err = @shell.eval_input('{')
      result.should.eq nil
      err.should.kind_of?(SyntaxError)
      @shell.config[:line].should.eq @line + 1
    end
  end

  should 'call after_loop even if in_loop raises' do
    mock(@shell).loop_once{ raise 'boom' }
    mock(Rib).warn(is_a(String))
    mock(@shell).after_loop
    lambda{@shell.loop}.should.raise(RuntimeError)
  end
end
