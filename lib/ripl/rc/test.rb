
require 'ripl'
require 'readline'
Ripl.config.merge!(:readline => nil) unless
  Readline::HISTORY.respond_to?(:clear) # EditLine is broken

require 'bacon'
require 'rr'
require 'fileutils'
Bacon.summary_on_exit
include RR::Adapters::RRMethods
