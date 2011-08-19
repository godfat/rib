
require 'rib/core/readline'  # dependency
require 'rib/core/multiline' # dependency

module Rib::Autoindent
  include Rib::Plugin
  Shell.use(self)

  BLOCK_REGEXP = {
    /begin/   => /end/,
    /def \S+/ => /end/
  }

  def before_loop
    return super if Autoindent.disabled?
    config[:autoindent_stack] ||= []
    config[:autoindent_space] ||= '  '
    super
  end

  def get_input
    return super if Autoindent.disabled?
    config[:autoindent_stack].clear if multiline_buffer.empty?
    Thread.new do
      sleep(0.01)
      ::Readline.line_buffer = current_autoindent
    end
    super
  end

  def loop_eval input
    return super if Autoindent.disabled?
    if s = handle_autoindent(input.strip)
      super(s || input)
    else
      super
    end
  end

  def handle_autoindent input
    down, up = BLOCK_REGEXP.find{ |d, u|
      break [d  , nil] if input =~ d
      break [nil,   u] if input =~ u
    }

    if down
      config[:autoindent_stack] << down
      nil
    elsif up == BLOCK_REGEXP[config[:autoindent_stack].last]
      config[:autoindent_stack].pop
      new_input = "#{current_autoindent}#{input}"
      puts("\e[1A\e[K#{prompt}#{new_input}")
      new_input
    end
  end

  def current_autoindent
    config[:autoindent_space] * config[:autoindent_stack].size
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
