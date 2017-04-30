
require 'rib/core/history' # dependency

module Rib; module SqueezeHistory
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  # squeeze history in memory too
  def loop_once
    return super if SqueezeHistory.disabled?
    begin
      input, last_input = history[-1], history[-2]
    rescue IndexError # EditLine is really broken, to_a is needed for it
      array = history.to_a
      input, last_input = array[-1], array[-2]
    end
    history.pop if input.to_s.strip == '' ||
                  (history.size > 1 && input == last_input)
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
end; end
