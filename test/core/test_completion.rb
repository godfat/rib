
require 'rib/test'
require 'rib/core/completion'

describe Rib::Completion do
  behaves_like :rib

  before do
    @completion = Class.new do
      include Rib::Completion
    end.new
  end

  should "#before_loop adds gem plugin to config" do
    $LOADED_FEATURES << '/dir/ripl/some_plugin.rb'
    @completion.send(:ripl_plugins).should == ['ripl/some_plugin.rb']
  end
end
