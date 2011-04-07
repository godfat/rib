
require 'bacon'
require 'rr'
require 'fileutils'
require 'ripl/rc/squeeze_history'
Bacon.summary_on_exit
include RR::Adapters::RRMethods

describe Ripl::Rc::SqueezeHistory do
  before do
    @history = '/tmp/test_ripl_history'
    Ripl.config.merge!(:history => @history, :irbrc => nil)
    @shell   = Ripl::Shell.create(Ripl.config)
    @input   = %w[foo bar bar foo bar]
    @shell.before_loop
    @shell.history.clear
  end

  after do; FileUtils.rm_f(@history); Ripl.enable_squeeze_history; end

  should 'after_loop saves squeezed history' do
    @shell.history.push(*@input)
    @shell.instance_variable_set('@input', '')
    @shell.after_loop
    File.read(@history).should == %w[foo bar foo bar].join("\n") + "\n"
  end

  should 'loop_once squeeze history' do
    times = @input.size
    stub(@shell).get_input{ (@shell.history << "'#{@input.shift}'")[-1] }
    stub(@shell).print_result(anything)
    times.times{ @shell.loop_once }
    @shell.history.to_a.should == %w[foo bar foo bar].map{ |i| "'#{i}'" }
  end

  should 'be disabled if disabled' do
    Ripl.disable_squeeze_history
    times = @input.size
    input = @input.dup
    stub(@shell).get_input{ (@shell.history << "'#{@input.shift}'")[-1] }
    stub(@shell).print_result(anything)
    times.times{ @shell.loop_once }
    @shell.history.to_a.should == input.map{ |i| "'#{i}'" }
  end
end
