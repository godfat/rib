
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
    @rc_multiline_buffer = []
    super
  end

  def prompt
    if @rc_multiline_buffer.empty?
      super
    else
      "#{' '*(@prompt.size-2)}| "
    end
  end

  def loop_once
    catch(:rc_multiline_cont) do
      super
      @rc_multiline_buffer.clear
    end
  end

  def print_eval_error(e)
    if e.is_a?(SyntaxError) && e.message =~ ERROR_REGEXP
      @rc_multiline_buffer << @input
      throw :rc_multiline_cont
    else
      super
    end
  end

  def loop_eval(input)
    if @rc_multiline_buffer.empty?
      super
    else
      super "#{@rc_multiline_buffer.join("\n")}\n#{input}"
    end
  end

  def handle_interrupt
    if @rc_multiline_buffer.empty?
      super
    else
      @rc_multiline_buffer.pop
      if @rc_multiline_buffer.empty?
        super
      else
        puts "[previous line removed]"
        throw :rc_multiline_cont
      end
    end
  end
end

Ripl::Shell.include(Ripl::Rc::Multiline)
