
require 'rib/test'
require 'rib/core/squeeze_history'
require 'tempfile'

copy :squeeze_history do
  would 'after_loop saves squeezed history' do
    @shell.history.push(*@input)
    @shell.after_loop
    File.read(@history).should.eq %w[foo bar foo bar].join("\n") + "\n"
  end

  would 'loop_once squeeze history' do
    times = @input.size
    stub(@shell).get_input{ (@shell.history << "'#{@input.shift}'").last }
    stub(@shell).print_result{}.with_any_args
    times.times{ @shell.loop_once }
    @shell.history.to_a.should.eq %w[foo bar foo bar].map{ |i| "'#{i}'" }
  end

  would 'be disabled if disabled' do
    Rib::SqueezeHistory.disable do
      times = @input.size
      input = @input.dup
      stub(@shell).get_input{ (@shell.history << "'#{@input.shift}'").last }
      stub(@shell).print_result{}.with_any_args
      times.times{ @shell.loop_once }
      @shell.history.to_a.should.eq input.map{ |i| "'#{i}'" }
    end
  end
end

describe Rib::SqueezeHistory do
  paste :rib

  test_for Rib::History, Rib::SqueezeHistory do
    before do
      @tempfile = Tempfile.new('rib')
      @history  = @tempfile.path
      @shell    = Rib::Shell.new(:history_file => @history).before_loop
      @input    = %w[foo bar bar foo bar]
      @shell.history.clear
    end

    after do
      @tempfile.unlink
    end

    paste :squeeze_history
  end
end
