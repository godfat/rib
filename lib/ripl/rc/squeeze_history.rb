
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::SqueezeHistory
  # write squeezed history
  def write_history
    File.open(history_file, 'w'){ |f|
      f.puts U.squeeze_history(history).join("\n")
    }
  end

  # squeeze history on memory too
  def eval_input input
    history.pop if input.strip == '' ||
                  (history.size > 1 && input == history[-2])
    super
  end

  module U
    module_function
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
end

Ripl::Shell.include(Ripl::Rc::SqueezeHistory)
