
require 'rib/test'
require 'rib/test/history'
require 'rib/core/squeeze_history'

describe Rib::SqueezeHistory do
  paste :rib

  test_for Rib::History, Rib::SqueezeHistory do
    paste :setup_history

    before do
      @input = %w[foo bar bar foo bar]
    end

    would 'after_loop saves squeezed history' do
      shell.history.push(*@input)
      shell.after_loop

      expect(File.read(history_file)).eq %w[foo bar foo bar].join("\n") + "\n"
    end

    would 'loop_once squeeze history' do
      stub_output
      stub(shell).get_input{ (shell.history << "'#{@input.shift}'").last }

      @input.size.times{ shell.loop_once }

      expect(shell.history.to_a).eq %w[foo bar foo bar].map{ |i| "'#{i}'" }
    end

    would 'be disabled if disabled' do
      Rib::SqueezeHistory.disable do
        stub_output
        stub(shell).get_input{ (shell.history << "'#{@input.shift}'").last }
        input = @input.dup

        @input.size.times{ shell.loop_once }

        expect(shell.history.to_a).eq input.map{ |i| "'#{i}'" }
      end
    end
  end
end
