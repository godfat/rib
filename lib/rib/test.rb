
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

  def for_each_plugin &block
    Rib.disable_plugins
    yield

    case ENV['TEST_LEVEL']
      when '0'
      when '1'
        Rib.plugins.each{ |plugin|
          Rib.disable_plugins
          plugin.enable
          yield
        }
      when '2'
        Rib.plugins.combination(2).each{ |plugins|
          Rib.disable_plugins
          plugins.each(&:enable)
          yield
        }
      when '3'
        rec_for_each_plugin(&block)
    end
  end

  def rec_for_each_plugin plugins=Rib.plugins, &block
    return yield if plugins.empty?
    plugins[0].enable
    rec_for_each_plugin(plugins[1..-1], &block)
    plugins[0].disable
    rec_for_each_plugin(plugins[1..-1], &block)
  end
end

module Kernel
  def eq? rhs
    self == rhs
  end
end
