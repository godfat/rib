
require 'rib/test'
require 'rib/core/history'

describe Rib::History do
  behaves_like :rib

  before do
    Rib::History.enable
    @history = "/tmp/test_rib_#{rand}"
    @shell   = Rib::Shell.new(:history => @history).before_loop
  end

  after do
    FileUtils.rm_f(@history)
  end

  should '#after_loop save history' do
    inputs = %w[blih blah]
    @shell.history.replace(inputs)
    @shell.after_loop
    File.read(@history).should.eq "#{inputs.join("\n")}\n"
  end

  should '#before_loop load previous history' do
    File.open(@history, 'w'){ |f| f.write "check\nthe\nmike" }
    @shell.before_loop
    @shell.history.to_a.should.eq %w[check the mike]
  end

  should '#before_loop have empty history if no history file exists' do
    @shell.before_loop
    @shell.history.to_a.should.eq []
  end

  should '#read_history be accessible to plugins in #before_loop' do
    mod = Module.new do
      def read_history
        @history = ['pong_read_history']
      end
    end
    shell = Rib::Shell.dup
    shell.use(mod)
    shell.new.before_loop.history.should.eq ['pong_read_history']
  end

  should '#write_history be accessible to plugins in #after_loop' do
    mod = Module.new do
      def write_history
        @history = ['pong_write_history']
      end
    end
    shell = Rib::Shell.dup
    shell.use(mod)
    shell.new.before_loop.after_loop.history.should.eq ['pong_write_history']
  end
end
