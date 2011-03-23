
require 'ripl'

# from https://github.com/janlelis/ripl-multi_line
module Ripl::Rc; end
module Ripl::Rc::Multiline
  ERROR_REGEXP = Regexp.new(
    [ "unexpected \\$end",
      "unterminated [a-z]+ meets end of file",
      # rubinius
      "expecting '\\\\n' or ';'",
      "missing 'end'",
      "expecting '}'",
      # jruby
      "syntax error, unexpected end-of-file",
    ].join('|'))

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
      @rc_multiline_buffer << @input if @rc_multiline_buffer.empty?
      history.pop
      throw :rc_multiline_cont
    else
      super
    end
  end

  def loop_eval(input)
    if @rc_multiline_buffer.empty?
      super
    else
      @rc_multiline_buffer << input
      history.pop
      history << "\n" + (str = @rc_multiline_buffer.join("\n"))
      super str
    end
  end

  def handle_interrupt
    if @rc_multiline_buffer.empty?
      super
    else
      line = @rc_multiline_buffer.pop
      if @rc_multiline_buffer.empty?
        super
      else
        puts "[removed this line: #{line}]"
        throw :rc_multiline_cont
      end
    end
  end
end

Ripl::Shell.include(Ripl::Rc::Multiline)
