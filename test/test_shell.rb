
require 'rib/test'
require 'rib/shell'

describe Rib::Shell do
  paste :rib

  describe '#loop' do
    def input str
      mock(shell).get_input{str}
      shell.loop
      ok
    end

    would 'exit'      do                              input('exit' ) end
    would 'also exit' do                              input(' exit') end
    would 'ctrl+d'    do mock(shell).puts{}         ; input(nil)     end
    would ':q'        do shell.config[:exit] << ':q'; input(':q')    end
    would '\q'        do shell.config[:exit] << '\q'; input('\q')    end

    would 'not puts anything if it is not running' do
      mock(shell).puts.times(0)

      shell.eval_binding.eval('self').instance_variable_set(:@shell, shell)

      input('@shell.stop; throw :rib_exit')
    end
  end

  describe '#loop_once' do
    def input str=nil
      if block_given?
        mock(shell).get_input{ yield }
      else
        mock(shell).get_input{ str }
      end
      shell.loop_once
      ok
    end

    would 'handles ctrl+c' do
      mock(shell).handle_interrupt{}
      input{ raise Interrupt }
    end

    would 'prints result' do
      mock(shell).puts('=> "mm"'){}
      input('"m" * 2')
    end

    would 'error in print_result' do
      mock(Rib).warn(matching(/Error while printing result.*BOOM/m)){}
      input('obj = Object.new; def obj.inspect; raise "BOOM"; end; obj')
    end

    would 'not crash if user input is a blackhole' do
      mock(Rib).warn(matching(/Error while printing result/)){}
      input('Rib::Blackhole')
    end

    would 'print error from eval' do
      mock(shell).puts(matching(/RuntimeError/)){}
      input('raise "blah"')
    end
  end

  describe '#prompt' do
    would 'be changeable' do
      shell.config[:prompt] = '> '
      shell.prompt.should.eq  '> '
    end
  end

  describe '#eval_input' do
    before do
      @line = shell.config[:line]
    end

    would 'line' do
      shell.eval_input('10 ** 2')
      shell.config[:line].should.eq @line + 1
    end

    would 'print error and increments line' do
      result, err = shell.eval_input('{')
      result.should.eq nil
      err.should.kind_of?(SyntaxError)
      shell.config[:line].should.eq @line + 1
    end
  end

  describe '#running?' do
    would 'have complete flow' do
      expect(shell).not.running?

      mock(shell).get_input do
        expect(shell).running?

        mock(shell).puts{}

        nil
      end

      shell.loop

      expect(shell).not.running?
    end
  end

  describe '#stop' do
    would 'stop the loop if it is stopped' do
      mock(shell).get_input do
        expect(shell).running?

        shell.stop

        expect(shell).not.running?

        'Rib::Skip'
      end

      shell.loop
    end
  end

  would 'call after_loop even if in_loop raises' do
    mock(shell).loop_once{ raise 'boom' }
    mock(Rib).warn(is_a(String)){}
    mock(shell).after_loop{}
    lambda{shell.loop}.should.raise(RuntimeError)
  end

  would 'have empty binding' do
    shell.eval_input('local_variables').first.should.empty?
  end

  would 'not pollute main' do
    shell.eval_input('main').first.should.eq 'rib'
  end

  would 'warn on removing main' do
    TOPLEVEL_BINDING.eval <<-RUBY
      singleton_class.module_eval do
        def main; end
      end
    RUBY
    mock(Rib).warn(is_a(String)){}
    shell.eval_input('main').first.should.eq 'rib'
  end

  would 'be main' do
    shell.eval_input('self.inspect').first.should.eq 'main'
  end
end
