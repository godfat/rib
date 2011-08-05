
require 'rib'

# from https://github.com/janlelis/ripl-multi_line
module Rib::Multiline
  include Rib::Plugin
  Shell.use(self)

  # test those:
  # ruby -e '"'
  # ruby -e '{'
  # ruby -e '['
  # ruby -e '('
  # ruby -e '/'
  # ruby -e 'class C'
  # ruby -e 'def f'
  # ruby -e 'begin'
  ERROR_REGEXP = Regexp.new(
    [ # string or regexp
      "unterminated \\w+ meets end of file",
      # mri and rubinius
      "syntax error, unexpected \\$end",
      # rubinius
      "expecting '.+'( or '.+')*",
      # jruby
      "syntax error, unexpected end-of-file",
    ].join('|'))

  def before_loop
    return super if Multiline.disabled?
    @multiline_buffer = []
    super
  end

  def prompt
    return super if Multiline.disabled?
    if @multiline_buffer.empty?
      super
    else
      "#{' '*(config[:prompt].size-2)}| "
    end
  end

  def loop_once
    return super if Multiline.disabled?
    catch(:multiline_cont) do
      super
      @multiline_buffer.clear
    end
  end

  def loop_eval(input)
    return super if Multiline.disabled?
    @multiline_buffer << input
    super(@multiline_buffer.join("\n"))
  end

  def print_eval_error(e)
    return super if Multiline.disabled?
    if e.is_a?(SyntaxError) && e.message =~ ERROR_REGEXP
      throw :multiline_cont
    else
      super
    end
  end

  def handle_interrupt
    return super if Multiline.disabled?
    if @multiline_buffer.empty?
      super
    else
      line = @multiline_buffer.pop
      print "[removed this line: #{line}]"
      super
      throw :multiline_cont
    end
  end
end
