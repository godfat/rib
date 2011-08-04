
require 'rib'
require 'bond'

module Rib::Completion
  include Rib::Plugin

  def before_loop
     config[:completion]                ||= {}
     config[:completion][:eval_binding] ||= lambda{ config[:binding] }
    (config[:completion][:gems]         ||= []).concat(ripl_plugins)
    Bond.start(config[:completion])
    super
  end

  protected
  def ripl_plugins
    $LOADED_FEATURES.map{ |e| e[/ripl\/[^\/]+$/] }.compact
  end

  Shell.use(self)
end
