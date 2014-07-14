
require 'rib/test'
require 'rib/core/completion'

describe Rib::Completion do
  paste :rib

  before do
    @completion = Class.new do
      include Rib::Completion
    end.new
  end

  would 'find correct ripl plugins' do
    $LOADED_FEATURES << '/dir/ripl/some_plugin.rb'
    @completion.send(:ripl_plugins).should.eq ['ripl/some_plugin.rb']
  end
end
