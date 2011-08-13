
require 'rib'

# from https://github.com/janlelis/ripl-multi_line
module Rib::Multiline
  include Rib::Plugin
  Shell.use(self)

  engine = if Object.const_defined?(:RUBY_ENGINE)
             RUBY_ENGINE
           else
             'ruby'
           end

  # test those:
  # ruby -e '"'
  # ruby -e '{'
  # ruby -e '['
  # ruby -e '('
  # ruby -e '/'
  # ruby -e 'class C'
  # ruby -e 'def f'
  # ruby -e 'begin'
  ERROR_REGEXP = case engine
    when 'ruby' ; Regexp.new(
                    [ # string or regexp
                      "unterminated \\w+ meets end of file",
                      # mri and rubinius
                      "syntax error, unexpected \\$end"]           .join('|'))
    when 'rbx'  ; Regexp.new(
                    [ # string or regexp
                      "unterminated \\w+ meets end of file",
                      # mri and rubinius
                      "syntax error, unexpected \\$end"    ,
                      # rubinius
                      "expecting '.+'( or '.+')*"          ,
                      "missing '.+' for '.+' started on line \\d+"].join('|'))
    when 'jruby'; Regexp.new(
                    [ # string or regexp
                      "unterminated \\w+ meets end of file",
                      # jruby
                      "syntax error, unexpected end-of-file"]      .join('|'))
    end

  # --------------- Rib API ---------------

  def loop_once
    return super if Multiline.disabled?
    result = nil
    catch(:rib_multiline) do
      result = super
      multiline_buffer.clear
    end
    result
  end

  def loop_eval input
    return super if Multiline.disabled?
    multiline_buffer << input
    super(multiline_buffer.join("\n"))
  end

  def print_eval_error err
    return super if Multiline.disabled?
    if multiline?(err)
      throw :rib_multiline
    else
      super
    end
  end

  def prompt
    return super if Multiline.disabled?
    if multiline_buffer.empty?
      super
    else
      "#{' '*(config[:prompt].size-2)}| "
    end
  end

  def handle_interrupt
    return super if Multiline.disabled?
    if multiline_buffer.empty?
      super
    else
      print "[removed this line: #{multiline_buffer.pop}]"
      super
      throw :rib_multiline
    end
  end

  # --------------- Plugin API ---------------

  def multiline? err
    err.is_a?(SyntaxError) && err.message =~ ERROR_REGEXP
  end



  private
  def multiline_buffer
    @multiline_buffer ||= []
  end
end
