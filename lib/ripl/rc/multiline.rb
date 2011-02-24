
require 'ripl'

# from https://github.com/janlelis/ripl-multi_line
module Ripl::Rc; end
module Ripl::Rc::Multiline
  ERROR_REGEXP = /#{
    [ %q%unexpected \$end%,
      %q%unterminated [a-z]+ meets end of file%,
      # rubinius
      %q%expecting '\\n' or ';'%,
      %q%missing 'end'%,
      %q%expecting '}'%,
      # jruby
      %q%syntax error, unexpected end-of-file%,
    ]*'|' }/

  def before_loop
    super
    @buffer = nil
  end

  def prompt
    if @buffer
      ' '*(@prompt.size-2) + '| '
    else
      super
    end
  end

  def loop_once
    catch(:multiline) do
      super
      @buffer = nil
    end
  end

  def print_eval_error(e)
    if e.is_a?(SyntaxError) && e.message =~ ERROR_REGEXP
      @buffer ||= []
      @buffer << @input
      throw :multiline
    else
      super
    end
  end

  def loop_eval(input)
    if @buffer
      super "#{@buffer.join("\n")}\n#{input}"
    else
      super input
    end
  end

  # remove last line from buffer
  # TODO: nicer interface (rewriting?)
  def handle_interrupt
    if @buffer
      @buffer.pop
      if @buffer.empty?
        @buffer = nil
        return super
      else
        puts "[previous line removed]"
        throw :multiline
      end
    else
      super
    end
  end
end

Ripl::Shell.include(Ripl::Rc::Multiline)
