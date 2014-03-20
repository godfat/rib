
require 'rib/test'
require 'rib/extra/autoindent'

describe Rib::Autoindent do
  behaves_like :rib

  Rib::Autoindent.enable

  autoindent = Class.new do
    include Rib::Autoindent, Rib::Multiline, Rib::API
    def config
      {:line => 0, :binding => TOPLEVEL_BINDING, :prompt => '>> '}
    end
    def stack_size
      autoindent_stack.size
    end
  end

  before do
    @indent = autoindent.new
    mock(@indent).puts(match(/^\e/)).times(0)
  end

  def ri input, size
    @indent.eval_input(input)
    @indent.stack_size.should.eq size
  end

  def le input, size
    mock(@indent).puts(match(/^\e/)){}
    @indent.eval_input(input)
    @indent.stack_size.should.eq size
  end

  should 'begin rescue else end' do
    @indent.stack_size.should.eq 0
    ri('begin'         , 1)
    ri(  '1'           , 1)
    le('rescue'        , 1)
    ri(  '1'           , 1)
    le('rescue=>e'     , 1)
    le('rescue => e'   , 1)
    le('rescue =>e'    , 1)
    le('rescue E=>e '  , 1)
    le('rescue E'      , 1)
    le('rescue E => e ', 1)
    le('rescue E=> e'  , 1)
    le('rescue E =>e ' , 1)
    le('else'          , 1)
    le('end while nil' , 0)
  end

  should 'if elsif else end' do
    ri('if true'       , 1)
    ri(  'if false'    , 2)
    ri(    '1'         , 2)
    le(  'end'         , 1)
    ri(  'if true'     , 2)
    le(  'elsif true'  , 2)
    ri(    '1'         , 2)
    le(  'else'        , 2)
    ri(    '1'         , 2)
    le(  'end'         , 1)
    ri(  'if 1'        , 2)
    ri(    'if 2'      , 3)
    le(    'end'       , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  should 'unless else end' do
    ri('unless 1'      , 1)
    ri(  'unless 1'    , 2)
    ri(    '1'         , 2)
    le(  'end '        , 1)
    le('else'          , 1)
    ri(  '1'           , 1)
    le('end'           , 0)
  end

  should 'case when else end' do
    ri('case 1'        , 1)
    le('when 1'        , 1)
    ri(  '1'           , 1)
    le('when 2'        , 1)
    ri('  if 1'        , 2)
    le('  end'         , 1)
    le('else'          , 1)
    ri(  '1'           , 1)
    le('end'           , 0)
  end

  should 'def end' do
    ri('def f a'       , 1)
    ri(  'if a'        , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  should 'class Object end' do
    ri('class Object'  , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  should 'module Rib end' do
    ri('module Rib'    , 1)
    ri(  'module_function', 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  should 'while end' do
    ri('while false'   , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  should 'until end' do
    ri('until true'    , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  should 'do end' do
    ri("to_s''do"      , 1)
    ri(  "to_s '' do"  , 2)
    le(  'end'         , 1)
    ri(  'to_s "" do'  , 2)
    le(  'end'         , 1)
    ri(  'to_s // do'  , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end
end
