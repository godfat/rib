
require 'bacon'
require 'rr'
require 'fileutils'
Bacon.summary_on_exit
include RR::Adapters::RRMethods

require 'rib'

shared :rib do
  before do
  end

  after do
    RR.verify
  end

  def for_each_plugin
    Rib.disable_plugins
    yield

    Rib.plugins.each{ |plugin|
      Rib.disable_plugins
      plugin.enable
      yield
    }
  end
end

module Kernel
  def eq? rhs
    self == rhs
  end
end
