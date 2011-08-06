
module Rib; end
module Rib::API
  # Called before shell starts looping
  def before_loop
    read_history
    self
  end

  # Called after shell finishes looping
  def after_loop
    write_history
    self
  end

  # Read config[:history_file] into #history, handled in history_file plugin
  def read_history
  end

  # Write #history into config[:history_file], handled in history_file plugin
  def write_history
  end

  # Handle interrupt (control-c)
  def handle_interrupt; puts               ; end
  # The prompt string of this shell
  def prompt       ; config[:prompt]       ; end
  # The result prompt string of this shell
  def result_prompt; config[:result_prompt]; end
  # The name of this shell
  def name         ; config[:name]         ; end
  # The binding for evaluation
  def eval_binding ; config[:binding]      ; end
  # The line number for next evaluation
  def line         ; config[:line]         ; end
  # The history data
  def history      ; @history ||= []       ; end

  # Main loop
  def in_loop
    input = catch(:rib_exit){ loop_once while true }
    puts if input == nil
  end

  # Loop iteration: REPL
  def loop_once
    self.error_raised = nil
    input = get_input
    throw(:rib_exit, input) if config[:exit].include?(input)
    if input.strip == ''
      eval_input(input)
    else
      print_result(eval_input(input))
    end
  rescue Interrupt
    handle_interrupt
  end

  # Get user input. This is most likely overrided in Readline plugin
  def get_input
    print(prompt)
    if input = $stdin.gets
      input.chomp
    else
      nil
    end
  end

  # Evaluate the input using #loop_eval and handle it
  def eval_input input
    loop_eval(input)
  rescue Exception => e
    self.error_raised = true
    print_eval_error(e)
  ensure
    config[:line] += 1
  end

  # Evaluate user input with #eval_binding, name and line
  def loop_eval input
    eval_binding.eval(input, "(#{name})", line)
  end

  # Print result using #format_result
  def print_result result
    puts(format_result(result)) unless error_raised
  rescue StandardError, SyntaxError => e
    Rib.warn("Error while printing result:\n  #{format_error(e)}")
  end

  # Print evaluated error using #format_error
  def print_eval_error err
    puts(format_error(err))
  rescue StandardError, SyntaxError => e
    Rib.warn("Error while printing error:\n  #{e}")
  end

  # Format result using #result_prompt
  def format_result result
    result_prompt + result.inspect
  end

  # Format error raised in #loop_eval
  def format_error err
    "#{err.class}: #{err.message}\n    #{err.backtrace.join("\n    ")}"
  end
end
