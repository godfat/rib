
require 'rib'

module Rib::Completion
  include Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if Completion.disabled?
     config[:completion]                ||= {}
     config[:completion][:eval_binding] ||= method(:eval_binding).to_proc
    (config[:completion][:gems]         ||= []).concat(ripl_plugins)
    Rib.silence{Bond.start(config[:completion]) unless Bond.started?}
    super
  end



  private
  def ripl_plugins
    $LOADED_FEATURES.map{ |e| e[/ripl\/[^\/]+$/] }.compact
  end
end

begin
  Rib.silence{require 'bond'}
rescue LoadError
  Rib.warn("Please install bond to use completion plugin:\n",
           "    gem install bond\n",
           "Or add bond to Gemfile if that's the case")
  Rib::Completion.disable
end
