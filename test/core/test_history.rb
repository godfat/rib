
require 'rib/test'
require 'rib/core/history'
require 'tempfile'

copy :history do
  would '#after_loop save history' do
    inputs = %w[blih blah]
    @shell.history.clear
    @shell.history.push(*inputs)

    @shell.after_loop
    File.read(@history_file).should.eq "#{inputs.join("\n")}\n"
  end

  would '#before_loop load previous history' do
    File.write(@history_file, "check\nthe\nmike")
    @shell.before_loop
    @shell.history.to_a.should.eq %w[check the mike]
  end

  would '#before_loop have empty history if no history file exists' do
    @shell.before_loop
    @shell.history.to_a.should.eq []
  end

  would '#read_history be accessible to plugins in #before_loop' do
    mod = Module.new do
      def read_history
        config[:history] = ['pong_read_history']
      end
    end
    shell = Rib::Shell.dup
    shell.use(mod)
    shell.new.before_loop.history.should.eq ['pong_read_history']
  end

  would '#write_history be accessible to plugins in #after_loop' do
    mod = Module.new do
      def write_history
        config[:history] = ['pong_write_history']
      end
    end
    shell = Rib::Shell.dup
    shell.use(mod)
    shell.new.before_loop.after_loop.history.should.eq ['pong_write_history']
  end
end

describe Rib::History do
  paste :rib

  test_for Rib::History do
    before do
      if readline?
        ::Readline::HISTORY.clear
        stub_readline
      end
      @tempfile     = Tempfile.new('rib')
      @history_file = @tempfile.path
      @shell        = Rib::Shell.new(
        :history_file => @history_file).before_loop
    end

    after do
      @tempfile.unlink
    end

    paste :history
  end
end
