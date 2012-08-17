
require 'rib/more/anchor'

module Rib::Debugger
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if Debugger.disabled?
    ::Debugger.handler = self
    bound_object.extend(Imp)

    context = config[:debugger_context]
    state, commands = ::Debugger::CommandProcessor.new.send(
      :always_run, context, config[:debugger_file], config[:debugger_line], 1)

    bound_object.singleton_class.
      send(:define_method, :method_missing) do |msg, *args, &block|
        if cmd = commands.find{ |c| c.match("#{msg}\n") }
          if context.dead? && cmd.class.need_context
            super(msg, *args, &block)
          else
            cmd.execute
            Rib::Skip
          end
        else
          super(msg, *args, &block)
        end
      end

    bound_object.help

    super
  end

  def at_line context, file, line
    puts "#{file}:#{line}"
    Rib.anchor(context.frame_binding(0), :prompt_anchor => false,
      :debugger_context => context,
      :debugger_file    => file,
      :debugger_line    => line)
  end

  module Imp
    def debug
      ::Debugger.handler = Rib.shell
      ::Debugger.start
      ::Debugger.current_context.stop_frame = 0
    end

    def step times=1
      ::Debugger.current_context.step(times)
      throw :rib_exit, Rib::Skip
    end
  end

  Rib.extend(Imp)
end

begin
  Rib.silence{ require 'debugger' }
  Kernel.module_eval{ private :debugger }
rescue LoadError => e
  Rib.warn("Error: #{e}"                                      ,
           "Please install debugger to use debugger plugin:\n",
           "    gem install debugger\n"                       ,
           "Or add debugger to Gemfile if that's the case")
  Rib::Debugger.disable
end
