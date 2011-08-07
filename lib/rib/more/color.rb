
require 'rib'

module Rib::Color
  include Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    config[:color] ||= {
      Numeric    => :red    ,
      String     => :green  ,
      Symbol     => :cyan   ,
      Array      => :blue   ,
      Hash       => :blue   ,
      NilClass   => :magenta,
      TrueClass  => :magenta,
      FalseClass => :magenta,
      Exception  => :magenta,
      Object     => :yellow
    }
    super
  end

  def format_result result
    return super if Color.disabled?
    config[:result_prompt] + format_color(result)
  end

  # --------------- Plugin API ---------------

  def colors; config[:color]; end

  def format_color result, display=result.inspect
    case result
      when String ; send(colors[String ]){ display }
      when Numeric; send(colors[Numeric]){ display }
      when Symbol ; send(colors[Symbol ]){ display }

      when Array  ; send(colors[Array  ]){ '['     }   +
                      result.map{ |e   | format_color(e) }.
               join(send(colors[Array  ]){ ', '    })  +
                    send(colors[Array  ]){ ']'     }

      when Hash   ; send(colors[Hash   ]){ '{'     }   +
                      result.map{ |k, v| format_color(k) +
                    send(colors[Hash   ]){ '=>'    }   +
                                         format_color(v) }.
               join(send(colors[Hash   ]){ ', '    }) +
                    send(colors[Hash   ]){ '}'     }

      else        ; if color = find_color(colors, result)
                    send(color){ display }
                    else
                    send(colors[Object      ]){ display }
                    end
    end
  end

  # --------------- Plugin API ---------------

  # override StripBacktrace#get_error
  def get_error err, backtrace=err.backtrace
    return super if Color.disabled?
    [format_color(err, "#{err.class.to_s}: #{err.message}"),
     backtrace.map{ |b|
       path, rest = ::File.split(b)
       name, msgs = rest.split(':', 2)
       msg = msgs.sub(/(\d+):/){red{$1}+':'}.sub(/`.+?'/){green{$&}}

       "#{path+'/'}#{yellow{name}}:#{msg}"
     }]
  end



  module_function
  def find_color colors, value
    (colors.sort{ |(k1, v1), (k2, v2)|
      # Class <=> Class
      if    k1 < k2 then -1
      elsif k1 > k2 then  1
      else                0
      end}.find{ |(klass, _)| value.kind_of?(klass) } || []).last
  end

  def color rgb
    "\x1b[#{rgb}m" + (block_given? ? "#{yield}#{reset}" : '')
  end

  def   black &block; color(30, &block); end
  def     red &block; color(31, &block); end
  def   green &block; color(32, &block); end
  def  yellow &block; color(33, &block); end
  def    blue &block; color(34, &block); end
  def magenta &block; color(35, &block); end
  def    cyan &block; color(36, &block); end
  def   white &block; color(37, &block); end
  def   reset &block; color('', &block); end
end
