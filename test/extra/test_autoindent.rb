
require 'rib/test'
require 'rib/extra/autoindent'

describe Rib::Autoindent do
  paste :rib

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
    Rib::Multiline.enable
    Rib::Autoindent.enable
    @indent = autoindent.new

    mock(@indent).puts(matching(/^\e/)).times(0)

    expect(@indent.stack_size).eq 0
  end

  def ri input, size
    @indent.eval_input(input)

    expect(@indent.stack_size).eq size
  end

  def le input, size
    mock(@indent).puts(matching(/^\e/)){}

    @indent.eval_input(input)

    expect(@indent.stack_size).eq size
  end

  would 'begin rescue else end' do
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

  would 'if elsif else end' do
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

  would 'unless else end' do
    ri('unless 1'      , 1)
    ri(  'unless 1'    , 2)
    ri(    '1'         , 2)
    le(  'end '        , 1)
    le('else'          , 1)
    ri(  '1'           , 1)
    le('end'           , 0)
  end

  would 'case when else end' do
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

  would 'def end' do
    ri('def f a'       , 1)
    ri(  'if a'        , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  would 'class Object end' do
    ri('class Object'  , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  would 'module Rib end' do
    ri('module Rib'    , 1)
    ri(  'module_function', 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  would 'while end' do
    ri('while false'   , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  would 'for end' do
    ri('for x in 1..2' , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  would 'until end' do
    ri('until true'    , 1)
    ri(  'if true'     , 2)
    le(  'end'         , 1)
    le('end'           , 0)
  end

  would 'do end' do
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
