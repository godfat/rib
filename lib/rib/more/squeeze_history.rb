
require 'rib/core/history'

module Rib::SqueezeHistory
  include Rib::Plugin
  Shell.use(self)

  # squeeze history on memory too
  def eval_input input
    return super if SqueezeHistory.disabled?
    history.pop if input.strip == '' ||
                  (history.size > 1 && input == history.to_a[-2])
                  # EditLine is really broken, to_a is needed for it
    super
  end

  # write squeezed history
  def write_history
    return super if SqueezeHistory.disabled?
    @history = P.squeeze_history(history)
    super
  end

  module Imp
    def squeeze_history history
      history.to_a.inject([]){ |result, item|
        if result.last == item
          result
        else
          result << item
        end
      }
    end
  end

  Plugin.extend(Imp)
end
