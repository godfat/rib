
require 'rib/plugin'

class Rib::Shell
  def self.use mod
    include mod
  end

  attr_reader :config
  def initialize(config={})
    self.config = {
      :name          => 'rib'                    ,
      :result_prompt => '=> '                    ,
      :prompt        => '>> '                    ,
      :binding       => TOPLEVEL_BINDING         ,
      :rc            => '~/.config/rib/config.rb',
      :exit          => [nil, 'exit', 'quit']    ,
      :line          => 1
    }.merge(config)
  end

  # Loops shell until user exits
  def loop
    before_loop
    in_loop
  ensure
    after_loop
  end

  protected
  attr_writer :config
  attr_accessor :error_raised

  module API
    # Sets up shell before looping by loading ~/.irbrc. Can be extended to
    # initialize plugins and their instance variables.
    def before_loop
      if File.exist?(rc = File.expand_path(config[:rc]))
        require rc
      end
    end

    def in_loop
      input = catch(:rib_exit){ loop_once while true}
      puts if input == nil
    end

    # Runs through one loop iteration: gets input, evals and prints result
    def loop_once
      self.error_raised = nil
      input = get_input
      throw(:rib_exit, input) if config[:exit].include?(input)
      if input.strip == ''
        history.pop
      else
        print_result(eval_input(input))
      end
    rescue Interrupt
      handle_interrupt
    end

    # Handles interrupt (Control-C) by printing a newline
    def handle_interrupt() puts end

    # Sets @result to result of evaling input and print unexpected errors
    def eval_input(input)
      loop_eval(input)
    rescue Exception => e
      self.error_raised = true
      print_eval_error(e)
    ensure
      config[:line] += 1
    end

    # When extending this method, ensure your plugin disables readline:
    # Readline.config[:readline] = false.
    # @return [String, nil] Prints #prompt and returns input given by user
    def get_input
      print(prompt)
      if input = $stdin.gets
        input.chomp
      else
        nil
      end
    end

    # @return [String]
    def prompt
      config[:prompt]
    end

    def read_history
    end

    def write_history
    end

    def history
    end

    # Evals user input using @binding, @name and @line
    def loop_eval(input)
      eval(input, config[:binding], "(#{config[:name]})", config[:line])
    end

    # Prints error formatted by #format_error to STDERR. Could be extended to
    # handle certain exceptions.
    # @param [Exception]
    def print_eval_error(err)
      warn format_error(err)
    end

    # Prints result using #format_result
    def print_result(result)
      puts(format_result(result)) unless error_raised
    rescue StandardError, SyntaxError => e
      warn "#{config[:name]}: Error while printing result:\n" \
           "#{format_error(e)}"
    end

    # Formats errors raised by eval of user input
    # @param [Exception]
    # @return [String]
    def format_error(e)
      "#{e.class}: #{e.message}\n    #{e.backtrace.join("\n    ")}"
    end

    # @return [String] Formats result using result_prompt
    def format_result(result)
      config[:result_prompt] + result.inspect
    end

    # Called after shell finishes looping.
    def after_loop
    end
  end

  include API
end
