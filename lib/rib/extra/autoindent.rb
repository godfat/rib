
require 'rib/core/readline'  # dependency
require 'rib/core/multiline' # dependency

module Rib::Autoindent
  include Rib::Plugin
  Shell.use(self)

  BLOCK_REGEXP = {
    /begin/                => /end/,
    /do/                   => /end/,
    /def \S+/              => /end/,
    /class \S+(\s+\<\S+)?/ => /end/,
    /\{/                   => /\}/
  }

  # --------------- Rib API ---------------

  def before_loop
    return super if Autoindent.disabled?
    config[:autoindent_spaces] ||= '  '
    super
  end

  def get_input
    return super if Autoindent.disabled?
    autoindent_stack.clear if multiline_buffer.empty?
    Thread.new do
      sleep(0.01)
      ::Readline.line_buffer = current_autoindent
    end
    super
  end

  def loop_eval input
    return super if Autoindent.disabled?
    if indented = handle_autoindent(input.strip)
      super(indented)
    else
      super
    end
  end

  # --------------- Plugin API ---------------

  def handle_autoindent input
    down, up = BLOCK_REGEXP.find{ |d, u|
      break [d  , nil] if input =~ d
      break [nil,   u] if input =~ u
    }

    if down
      autoindent_stack << down
      nil
    elsif up == BLOCK_REGEXP[autoindent_stack.last]
      autoindent_stack.pop
      new_input = "#{current_autoindent}#{input}"
      puts("\e[1A\e[K#{prompt}#{new_input}")
      new_input
    end
  end



  private
  def current_autoindent size=autoindent_stack.size
    config[:autoindent_spaces] * size
  end

  def autoindent_stack
    @autoindent_stack ||= []
  end
end

begin
  require 'readline_buffer'
rescue LoadError
  Rib.warn("Please install readline_buffer to use autoindent plugin:\n",
           "    gem install readline_buffer\n",
           "Or add readline_buffer to Gemfile if that's the case")
  Rib::Autoindent.disable
end
