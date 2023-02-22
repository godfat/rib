# frozen_string_literal: true

require 'rib/core/history'   # otherwise the order might be wrong
require 'rib/core/readline'  # dependency
require 'rib/core/multiline' # dependency

module Rib; module Autoindent
  extend Plugin
  Shell.use(self)

  # begin block could be simpler, because it should also trigger
  # SyntaxError, otherwise indention would be wiped out.
  # but end block should be exactly match, because we don't have
  # SyntaxError information, also triggering SyntaxError doesn't
  # mean it's not an end block, thinking about nested multiline!
  BLOCK_REGEXP = {
    # rescue Expression? (=> VariableName)?
    # consider cases:
    # rescue
    # rescue=>e
    # rescue => e
    # rescue =>e
    # rescue E=>e
    # rescue E
    # rescue E => e
    # rescue E=> e
    # rescue E =>e
    # ensure
    /^begin$/ =>
      /^(end)\b|^else$|^rescue *((\w+)? *(=> *\w+)?)?$|^ensure$/,
    /^def\b/  =>
      /^(end)\b|^else$|^rescue *((\w+)? *(=> *\w+)?)?$|^ensure$/,
    # elsif Expression
    # consider cases:
    # elsif(true)
    # elsif true
    # elsif true == true
    # elsif (a = true) && false
    /^if\b/            => /^(end)\b|^else$|^elsif\b/,
    /^unless\b/        => /^(end)\b|^else$|^elsif\b/,
    /^case\b/          => /^(end)\b|^else$|when\b/  ,
    /^class\b/         => /^(end)\b/                ,
    /^module\b/        => /^(end)\b/                ,
    /^while\b/         => /^(end)\b/                ,
    /^for\b/           => /^(end)\b/                ,
    /^until\b/         => /^(end)\b/                ,
    # consider cases:
    # 'do
    # ' do
    # "' do
    # /do
    # '{
    # %q{
    # %q| do
    # hey, two lines are even harder!
    # "
    # begin
    /do( *\|.*\|)?$/ => /^(end)\b/                ,
    /\{( *\|.*\|)?$/ => /^(\})\B/                 ,
    /\($/            => /^(\))\B/                 ,
    /\[$/            => /^(\])\B/                 ,
    # those are too hard to deal with, so we use syntax error to double check
    # what about this then?
    # v = if true
    #     else
    #     end
  }

  # --------------- Rib API ---------------

  def before_loop
    return super if Autoindent.disabled?
    autoindent_spaces
    super
  end

  def get_input
    return super if Autoindent.disabled?
    # this is only a fix in case we don't autoindent correctly
    # if we're autoindenting 100% correct, then this is a useless check
    autoindent_stack.clear if multiline_buffer.empty?

    # this should be called after ::Readline.readline, but it's blocking,
    # and i don't know if there's any hook to do this, so here we use thread
    Thread.new do
      sleep(0.01)
      ::Readline.line_buffer = current_autoindent if
        ::Readline.line_buffer && ::Readline.line_buffer.empty?
    end

    super
  end

  def eval_input raw_input
    return super if Autoindent.disabled?
    input  = raw_input.strip
    indent = detect_autoindent(input)
    result, err = super
    handle_autoindent(input, indent, err)
    [result, err]
  end

  # --------------- Plugin API ---------------

  def detect_autoindent input
    _, backmark = BLOCK_REGEXP.find{ |key,  _| input =~ key }
    if backmark # e.g. begin
      [:right, backmark]
    elsif input =~ autoindent_stack.last
      if $1     # e.g. end, }, etc
        [:left_end]
      else      # e.g. elsif, rescue, etc
        [:left_tmp]
      end
    else
      [:stay]
    end
  end

  def handle_autoindent input, indent, err
    case indent.first
    when :right    # we need to go deeper
      if multiline?(err)
        if err.message =~ /unterminated \w+ meets end of file/
          # skip if we're in the middle of a string or regexp
        else
          # indent.last is the way (input regexp matches) to go back
          autoindent_stack << indent.last
        end
      end

    when :left_end # we need to go back
      # could happen in either multiline or not
      handle_last_line(input)
      autoindent_stack.pop

    when :left_tmp # temporarily go back
      handle_last_line(input) if multiline?(err)
    end
  end

  def handle_last_line input,
                       indent=current_autoindent(autoindent_stack.size-1)
    new_input = "#{indent}#{input}"
    puts("\e[1A\e[K#{prompt}#{new_input}")
    new_input
  end



  private
  def current_autoindent size=autoindent_stack.size
    autoindent_spaces * size
  end

  def autoindent_spaces
    config[:autoindent_spaces] ||= '  '
  end

  def autoindent_stack
    @autoindent_stack ||= []
  end
end; end

begin
  require 'readline_buffer'
rescue LoadError => e
  Rib.warn("Error: #{e}"                                               ,
           "Please install readline_buffer to use autoindent plugin:\n",
           "    gem install readline_buffer\n"                         ,
           "Or add readline_buffer to Gemfile if that's the case"      )
  Rib::Autoindent.disable
end
