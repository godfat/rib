
require 'rib'

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

begin
  require 'bond'
rescue LoadError
  Rib.warn("Please install bond to use completion plugin:\n",
           "    gem install bond\n",
           "Or add bond to Gemfile if that's the case")
  Rib::Completion.disable
end
