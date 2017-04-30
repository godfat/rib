
require 'rib'

module Rib; module Completion
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if Completion.disabled?
    config[:completion]                ||= {}
    config[:completion][:gems]         ||= []
    config[:completion][:eval_binding] ||= method(:eval_binding).to_proc
    Rib.silence{Bond.start(config[:completion]) unless Bond.started?}
    super
  end
end; end

begin
  Rib.silence{require 'bond'}
rescue LoadError => e
  Rib.warn("Error: #{e}"                                    ,
           "Please install bond to use completion plugin:\n",
           "    gem install bond\n"                         ,
           "Or add bond to Gemfile if that's the case"      )
  Rib::Completion.disable
end
