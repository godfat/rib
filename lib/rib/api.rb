
module Rib; end
module Rib::API
  # Called before shell starts looping
  def before_loop
    self
  end

  # Called after shell finishes looping
  def after_loop
    self
  end

  # Handle interrupt (control-c)
  def handle_interrupt; puts                ; end
  # The prompt string of this shell
  def prompt       ; config[:prompt]        ; end
  # The result prompt string of this shell
  def result_prompt; config[:result_prompt] ; end
  # The name of this shell
  def name         ; config[:name]          ; end
  # The binding for evaluation
  def eval_binding ; config[:binding]       ; end
  # The line number for next evaluation
  def line         ; config[:line]          ; end
  # The object for the current binding
  def bound_object
    config[:bound_object] ||= eval_binding.eval('self', __FILE__, __LINE__)
  end

  # Main loop
  def in_loop
    input = catch(:rib_exit){ loop_once while true }
    puts if input == nil
  end

  # Loop iteration: REPL
  def loop_once
    input, result, err = get_input, nil, nil
    throw(:rib_exit, input) if config[:exit].include?(input)
    result, err = eval_input(input)
    if err
      print_eval_error(err)
    elsif input.strip != '' && !equal_rib_skip(result)
      print_result(result)
    else
      # print nothing for blank input or Rib::Skip
    end
    [result, err]
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
    [loop_eval(input), nil]
  rescue SystemExit
    throw(:rib_exit, input)
  rescue Exception => e
    [nil, e]
  ensure
    config[:line] += 1
  end

  # Evaluate user input with #eval_binding, name and line
  def loop_eval input
    eval_binding.eval(input, "(#{name})", line)
  end

  # Print result using #format_result
  def print_result result
    puts(format_result(result))
  rescue StandardError, SyntaxError => e
    Rib.warn("Error while printing result:\n  #{format_error(e)}")
  end

  # Print evaluated error using #format_error
  def print_eval_error err
    puts(format_error(err))
  rescue StandardError, SyntaxError => e
    Rib.warn("Error while printing error:\n  #{format_error(e)}")
  end

  def puts str
    super
  end

  # Format result using #result_prompt
  def format_result result
    result_prompt + result.inspect
  end

  # Format error raised in #loop_eval with #get_error
  def format_error err
    message, backtrace = get_error(err)
    "#{message}\n    #{backtrace.join("\n    ")}"
  end
  module_function :format_error

  # Get error message and backtrace from a particular error
  def get_error err
    ["#{err.class}: #{err.message}", format_backtrace(err.backtrace)]
  end
  module_function :get_error

  def format_backtrace backtrace
    backtrace
  end

  private
  def equal_rib_skip result
    result == Rib::Skip
  rescue
    # do nothing, it cannot respond to == correctly, it can't be Rib::Skip
  end
end
