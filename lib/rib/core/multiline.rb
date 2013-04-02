
require 'rib'

# from https://github.com/janlelis/ripl-multi_line
module Rib::Multiline
  extend Rib::Plugin
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
  # ruby -e 'eval "1+1.to_i +"'
  # ruby -e 'eval "1+1.to_i -"'
  # ruby -e 'eval "1+1.to_i *"'
  # ruby -e 'eval "1+1.to_i /"'
  # ruby -e 'eval "1+1.to_i &"'
  # ruby -e 'eval "1+1.to_i |"'
  # ruby -e 'eval "1+1.to_i ^"'
  BINARY_OP = %w[tUPLUS tUMINUS tSTAR tREGEXP_BEG tAMPER]
  RUBY20_IO = %w[unary+ unary-  *     tREGEXP_BEG &].
              map(&Regexp.method(:escape))
  ERROR_REGEXP = case engine
    when 'ruby' ; Regexp.new(
                    [ # string or regexp
                      "unterminated \\w+ meets end of file",
                      # mri and rubinius
                      "unexpected (#{BINARY_OP.join('|')}), expecting \\$end",
                      "syntax error, unexpected \\$end"    ,
                      # ruby 2.0
                      "syntax error, unexpected end-of-input",
                      "syntax error, unexpected (#{RUBY20_IO.join('|')}),"
                                                                  ].join('|'))
    when 'rbx'  ; Regexp.new(
                    [ # string or regexp
                      "unterminated \\w+ meets end of file",
                      # mri and rubinius
                      "syntax error, unexpected \\$end"    ,
                      # rubinius
                      "expecting \\$end"                   ,
                      "expecting '.+'( or '.+')*"          ,
                      "missing '.+' for '.+' started on line \\d+"].join('|'))
    when 'jruby'; Regexp.new(
                    [ # string or regexp
                      "unterminated \\w+ meets end of file",
                      # jruby
                      "syntax error, unexpected" \
                      " t(UPLUS|UMINUS|STAR|REGEXP_BEG|AMPER)",
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
      mprompt = multiline_prompt[0, config[:prompt].size]
      "#{' '*(config[:prompt].size-mprompt.size)}#{mprompt}"
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

  def multiline_prompt
    config[:multiline_prompt] ||= '| '
  end


  private
  def multiline_buffer
    @multiline_buffer ||= []
  end
end
