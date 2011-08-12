
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

  def test_for *plugins, &block
    rest = Rib.plugins - plugins
    Rib.enable_plugins(plugins)
    Rib.disable_plugins(rest)
    yield

    case ENV['TEST_LEVEL']
      when '0'
      when '1'
        rest.each{ |target|
          target.enable
          yield
          target.disable
        }
      when '2'
        rest.combination(2).each{ |targets|
          Rib.enable_plugins(targets)
          yield
          Rib.disable_plugins(targets)
        }
      when '3'
        rec_test_for(rest, &block)
    end
  end

  def rec_test_for rest, &block
    return yield if rest.empty?
    rest[0].enable
    rec_test_for(rest[1..-1], &block)
    rest[0].disable
    rec_test_for(rest[1..-1], &block)
  end
end

module Kernel
  def eq? rhs
    self == rhs
  end
end
