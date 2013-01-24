
require 'rib/more/anchor'

module Rib::Debugger
  extend Rib::Plugin
  Shell.use(self)

  ExcludedCommands = %w[irb quit exit backtrace eval p pp ps]
   WrappedCommands = %w[help where edit reload]

  # --------------- Rib API ---------------

  def before_loop
    return super if Debugger.disabled?
    ::Debugger.handler = self
    bound_object.extend(Imp)
    @debugger_state ||= config[:debugger_state]
    @debugger_watch ||= config[:debugger_watch]
    bound_object.display(debugger_watch.shift) until debugger_watch.empty?
    super
  end

  # --------------- Plugin API ---------------

  def debugger_watch
    @debugger_watch ||= []
  end

  def debugger_state
    @debugger_state ||= config[:debugger_state] ||
      ::Debugger::CommandProcessor::State.new{ |s|
        commands = ::Debugger::Command.commands.select{ |cmd|
          cmd.event                                                      &&
          (!config[:debugger_context].dead? || cmd.allow_in_post_mortem) &&
          !ExcludedCommands.include?([cmd.help_command].flatten.first)
        }

        s.context = config[:debugger_context]
        s.file    = config[:debugger_file]
        s.line    = config[:debugger_line]
        s.binding = config[:debugger_context].frame_binding(0)
        s.display = []
        s.interface = ::Debugger::LocalInterface.new
        s.commands  = commands
      }
  end

  # Callback for the debugger
  def at_line context, file, line
    return if Debugger.disabled?
    path = "#{file}:#{line}:in #{caller[1][/`.+?'/]}"
    msg0 = if Rib.const_defined?(:StripBacktrace) && StripBacktrace.enabled?
             StripBacktrace.strip_backtrace([path])
           else
             [path]
           end
    msg1 = if Rib.const_defined?(:Color) && Color.enabled?
             Color.colorize_backtrace(msg0)
           else
             [msg0].flatten
           end

    Rib.say(msg1.first)

    if @debugger_state
      @debugger_state.context = context
      @debugger_state.file    = file
      @debugger_state.line    = line
    end
    Rib::Anchor.enable
    Rib.anchor(context.frame_binding(0), :prompt_anchor => false,
      :debugger_context => context,
      :debugger_file    => file   ,
      :debugger_line    => line   ,
      :debugger_state   => @debugger_state,
      :debugger_watch   => @debugger_watch)
    ::Debugger.stop
  rescue Exception => e
    Rib.warn("Error while calling at_line:\n  #{format_error(e)}")
  end

  module Imp
    def debug
      return if Rib::Debugger.disabled?
      ::Debugger.handler = Rib.shell
      ::Debugger.start
      ::Debugger.current_context.stop_frame = 0
    end

    # You can `Rib.watch` a number of expressions before calling `Rib.debug`
    def watch *strs
      Rib.shell.debugger_watch.concat(strs)
    end

    def step times=1
      ::Debugger.current_context.step(times)
      display
      throw :rib_exit, Rib::Skip
    end

    WrappedCommands.each{ |cmd|
      module_eval <<-RUBY
        def #{cmd} *args
          debugger_execute('#{cmd}', args)
        end
      RUBY
    }

    def display *args
      if args.empty?
        debugger_execute('display', args, 'Display')
      else
        debugger_execute('display', args, 'AddDisplay')
      end
    end
    alias_method :disp, :display

    def list *args
      debugger_execute('list', args, 'List', Rib.shell.debugger_state.dup)
    end
    alias_method :ls, :list

    def debugger_execute command, args=[], name=command.capitalize,
                         state=Rib.shell.debugger_state
      const = "#{name}Command"
      arg = if args.empty? then '' else " #{args.join(' ')}" end
      cmd = ::Debugger.const_get(const).new(state)
      cmd.match("#{command}#{arg}\n")
      cmd.execute
      Rib::Skip
    end
  end

  Rib.extend(Imp)
end

begin
  Rib.silence{ require 'debugger' }
  require 'rib/patch/debugger'
rescue LoadError => e
  Rib.warn("Error: #{e}"                                      ,
           "Please install debugger to use debugger plugin:\n",
           "    gem install debugger\n"                       ,
           "Or add debugger to Gemfile if that's the case")
  Rib::Debugger.disable
end
