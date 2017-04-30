
module Rib; module API
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
  # When the application loaded
  def started_at   ; config[:started_at]    ; end

  # Main loop
  def in_loop
    input = catch(:rib_exit){ loop_once while running? }
    puts if input == nil && running?
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

    flush_warnings

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
    if eval_binding.kind_of?(Binding)
      eval_binding.eval(input, "(#{name})", line)
    else
      eval_binding.instance_eval(input, "(#{name})", line)
    end
  end

  # Print result using #format_result
  def print_result result
    puts(format_result(result))
  rescue StandardError, SyntaxError => e
    warn("Error while printing result:\n  #{format_error(e)}")
  end

  # Print evaluated error using #format_error
  def print_eval_error err
    puts(format_error(err))
  rescue StandardError, SyntaxError => e
    warn("Error while printing error:\n  #{format_error(e)}")
  end

  def puts str
    super
  end

  def warn message
    warnings << message
  end

  def flush_warnings
    Rib.warn(warnings.shift) until warnings.empty?
  end

  # Format result using #result_prompt
  def format_result result
    "#{result_prompt}#{inspect_result(result)}"
  end

  def inspect_result result
    string = result.inspect
    warn("#{result.class}#inspect is not returning a string") unless
      string.kind_of?(String)
    string
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
end; end
