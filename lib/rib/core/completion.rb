
require 'rib'
require 'bond'

module Rib::Completion
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    return super if Completion.disabled?
     config[:completion]                ||= {}
     config[:completion][:eval_binding] ||= lambda{ config[:binding] }
    (config[:completion][:gems]         ||= []).concat(ripl_plugins)
    Bond.start(config[:completion])
    super
  end

  private
  def ripl_plugins
    $LOADED_FEATURES.map{ |e| e[/ripl\/[^\/]+$/] }.compact
  end
end
