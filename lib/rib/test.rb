
require 'bacon'
require 'muack'
require 'fileutils'
Bacon.summary_on_exit
include Muack::API

require 'rib'

shared :rib do
  before do
  end

  after do
    Muack.verify
  end

  def test_for *plugins, &block
    require 'rib/all' # exhaustive tests
    rest = Rib.plugins - plugins
    Rib.enable_plugins(plugins)
    Rib.disable_plugins(rest)
    yield

    case ENV['TEST_LEVEL']
      when '0'
      when '1'
        test_level1(rest, block)
      when '2'
        test_level2(rest, block)
      when '3'
        test_level3(rest, block)
      else # test_level3 is too slow because of rr (i guess)
        test_level2(rest, block)
    end
  end

  def test_level1 rest, block
    rest.each{ |target|
      target.enable
      block.call
      target.disable
    }
  end

  def test_level2 rest, block
    rest.combination(2).each{ |targets|
      Rib.enable_plugins(targets)
      block.call
      Rib.disable_plugins(targets)
    }
  end

  def test_level3 rest, block
    return block.call if rest.empty?
    rest[0].enable
    test_level3(rest[1..-1], block)
    rest[0].disable
    test_level3(rest[1..-1], block)
  end

  def readline?
    Rib.constants.map(&:to_s).include?('Readline') &&
    Rib::Readline.enabled?
  end

  def stub_readline
    stub(::Readline).readline(is_a(String), true){
      (::Readline::HISTORY << str.chomp).last
    }
  end
end

module Kernel
  def eq? rhs
    self == rhs
  end
end

Rib::Blackhole = Object.new
b = Rib::Blackhole.singleton_class
b.instance_methods(true).each{ |m|
  b.send(:undef_method, m) unless
    [:object_id, :__send__, :__id__].include?(m) }
