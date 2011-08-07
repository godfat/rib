
require 'rib/core/history'

module Rib::SqueezeHistory
  include Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  # squeeze history on memory too
  def eval_input input
    return super if SqueezeHistory.disabled?
    history.pop if input.strip == '' ||
                  (history.size > 1 && input == history.to_a[-2])
                  # EditLine is really broken, to_a is needed for it
    super
  end

  # --------------- Plugin API ---------------

  # write squeezed history
  def write_history
    return super if SqueezeHistory.disabled?
    config[:history] = squeezed_history
    super
  end



  private
  def squeezed_history
    history.to_a.inject([]){ |result, item|
      if result.last == item || item.strip == ''
        result
      else
        result << item
      end
    }
  end
end
