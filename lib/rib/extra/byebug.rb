
require 'rib/more/anchor'
require 'byebug/core'

# This is based on lib/byebug/processors/pry_processor.rb

module Rib; module Byebug
  extend Plugin
  Shell.use(self)

  module Imp
    def byebug
      return if Rib::Byebug.disabled?

      ::Byebug::RibProcessor.start
    end

    def location
      Rib.shell.config[:byebug].location
    end

    def step times=1
      throw :rib_byebug, [:step, times]
    end

    def next lines=1
      throw :rib_byebug, [:next, lines]
    end

    def finish
      throw :rib_byebug, [:finish]
    end
  end

  Rib.extend(Imp)
end; end

module Byebug
  class RibProcessor < CommandProcessor
    def self.start
      Byebug.start
      Setting[:autolist] = false
      Context.processor = self
      steps = caller.index{ |path| !path.start_with?(__FILE__) }
      Byebug.current_context.step_out(steps + 2, true)
    end

    def at_line
      resume_rib
    end

    def at_return(_return_value)
      resume_rib
    end

    def at_end
      resume_rib
    end

    def at_breakpoint(breakpoint)
      raise NotImplementedError
    end

    def location
      context.location
    end

    private

    def print_location
      shell = Rib.shell
      shell.puts(shell.format_backtrace([location]).first)
    end

    def resume_rib
      byebug_binding = frame._binding

      print_location

      action, *args = catch(:rib_byebug) do
        allowing_other_threads do
          Rib.anchor byebug_binding, :byebug => self
        end
      end

      perform(action, args)
    end

    def perform action, args
      case action
      when :step
        context.step_into(*args, frame.pos)
      when :next
        context.step_over(*args, frame.pos)
      when :finish
        context.step_out(1)
      end
    end
  end
end
