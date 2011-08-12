
require 'rib/test'
require 'rib/more/squeeze_history'

shared :squeeze_history do
  should 'after_loop saves squeezed history' do
    @shell.history.push(*@input)
    @shell.after_loop
    File.read(@history).should.eq %w[foo bar foo bar].join("\n") + "\n"
  end

  should 'loop_once squeeze history' do
    times = @input.size
    stub(@shell).get_input{ (@shell.history << "'#{@input.shift}'")[-1] }
    stub(@shell).print_result(anything)
    times.times{ @shell.loop_once }
    @shell.history.to_a.should.eq %w[foo bar foo bar].map{ |i| "'#{i}'" }
  end

  should 'be disabled if disabled' do
    Rib::SqueezeHistory.disable
    times = @input.size
    input = @input.dup
    stub(@shell).get_input{ (@shell.history << "'#{@input.shift}'")[-1] }
    stub(@shell).print_result(anything)
    times.times{ @shell.loop_once }
    @shell.history.to_a.should.eq input.map{ |i| "'#{i}'" }
    Rib::SqueezeHistory.enable
  end
end

describe Rib::SqueezeHistory do
  behaves_like :rib

  before do
    @history = "/tmp/test_rib_#{rand}"
    @shell   = Rib::Shell.new(:history_file => @history).before_loop
    @input   = %w[foo bar bar foo bar]
    @shell.history.clear
  end

  after do
    FileUtils.rm_f(@history)
  end

  test_for Rib::History, Rib::SqueezeHistory do
    behaves_like :squeeze_history
  end
end
