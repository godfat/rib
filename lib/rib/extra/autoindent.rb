
require 'rib/core/readline'  # dependency
require 'rib/core/multiline' # dependency

module Rib::Autoindent
  include Rib::Plugin
  Shell.use(self)

  BLOCK_REGEXP = {
    /begin/                => /(end)|rescue/,
    /do/                   => /(end)/       ,
    /def \S+/              => /(end)/       ,
    /class \S+(\s+\<\S+)?/ => /(end)/       ,
    /\{/                   => /(\})/
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
      # this should be called after ::Readline.readline, but it's blocking,
      # and i don't know if there's any hook to do this, so here we use thread
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
    _, up = BLOCK_REGEXP.find{ |key,  _| input =~ key }
    if up
      autoindent_stack << up
      nil
    elsif input =~ autoindent_stack.last
      if $1 # e.g. end, }, etc
        autoindent_stack.pop
        handle_last_line(input)
      else # e.g. elsif, rescue, etc
        handle_last_line(input, current_autoindent(autoindent_stack.size-1))
      end
    end
  end

  def handle_last_line input, indent=current_autoindent
    new_input = "#{indent}#{input}"
    puts("\e[1A\e[K#{prompt}#{new_input}")
    new_input
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
