
require 'rib/test'
require 'rib/test/history'
require 'rib/core/history'

describe Rib::History do
  paste :rib
  paste :setup_history

  test_for Rib::History do
    would '#after_loop save history' do
      inputs = %w[blih blah]
      shell.history.push(*inputs)

      shell.after_loop

      expect(File.read(history_file)).eq "#{inputs.join("\n")}\n"
    end

    would '#before_loop load previous history' do
      File.write(history_file, "check\nthe\nmike")

      shell.before_loop

      expect(shell.history.to_a).eq %w[check the mike]
    end

    would '#before_loop have empty history if no history file exists' do
      expect(shell.history.to_a).eq []
    end

    would '#read_history be accessible to plugins in #before_loop' do
      mod = Module.new do
        def read_history
          config[:history] = ['pong_read_history']
        end
      end
      klass = Rib::Shell.dup
      klass.use(mod)

      shell = klass.new.before_loop

      expect(shell.history).eq ['pong_read_history']
    end

    would '#write_history be accessible to plugins in #after_loop' do
      mod = Module.new do
        def write_history
          config[:history] = ['pong_write_history']
        end
      end
      klass = Rib::Shell.dup
      klass.use(mod)

      shell = klass.new.before_loop.after_loop

      expect(shell.history).eq ['pong_write_history']
    end
  end
end
