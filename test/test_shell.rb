
require 'rib/test'
require 'rib/shell'

describe Rib::Shell do
  paste :rib

  describe '#loop' do
    def input str=Rib::Skip
      mock(shell).get_input{if block_given? then yield else str end}
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

    describe 'trap' do
      before do
        @token = Class.new(Exception)
        @old_trap = trap('INT'){ raise @token }
        mock(shell).handle_interrupt{ mock(shell).get_input{'exit'} }
      end

      after do
        trap('INT', &@old_trap)
      end

      def interrupt
        Process.kill('SIGINT', Process.pid)
        sleep
      end

      would 'fence and restore ctrl+c interruption' do
        input{ interrupt }

        expect.raise(@token){ interrupt }
      end
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

    %w[next break].each do |keyword|
      would "handle #{keyword}" do
        mock(shell).puts(matching(/^SyntaxError:/)){}

        input(keyword)
      end
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

      expect(shell.prompt).eq  '> '
    end
  end

  describe '#eval_input' do
    before do
      @line = shell.config[:line]
    end

    would 'line' do
      shell.eval_input('10 ** 2')

      expect(shell.config[:line]).eq @line + 1
    end

    would 'print error and increments line' do
      result, err = shell.eval_input('{')

      expect(result).eq nil
      expect(err).kind_of?(SyntaxError)
      expect(shell.config[:line]).eq @line + 1
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

    expect.raise(RuntimeError) do
      shell.loop
    end
  end

  would 'have empty binding' do
    expect(shell(:binding => nil).eval_input('local_variables').first).empty?
  end

  would 'not pollute main' do
    expect(shell(:binding => nil).eval_input('main').first).eq 'rib'
  end

  would 'be main' do
    expect(shell(:binding => nil).eval_input('self.inspect').first).eq 'main'
  end

  would 'warn on removing main' do
    mock(TOPLEVEL_BINDING.eval('singleton_class')).method_defined?(:main) do
      true
    end

    mock(Rib).warn(is_a(String)){}

    expect(shell(:binding => nil).eval_input('main').first).eq 'rib'
  end
end
