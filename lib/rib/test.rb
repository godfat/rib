
require 'bacon'
require 'rr'
require 'fileutils'
Bacon.summary_on_exit
include RR::Adapters::RRMethods

require 'rib'

shared :rib do
  before do
    Rib.disable_plugins
  end

  after do
    RR.verify
    Rib.enable_plugins
  end
end
