
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
      when String ; P.send(colors[String ]){ display }
      when Numeric; P.send(colors[Numeric]){ display }
      when Symbol ; P.send(colors[Symbol ]){ display }

      when Array  ; P.send(colors[Array  ]){ '['     }   +
                      result.map{ |e   | format_color(e) }.
               join(P.send(colors[Array  ]){ ', '    })  +
                    P.send(colors[Array  ]){ ']'     }

      when Hash   ; P.send(colors[Hash   ]){ '{'     }   +
                      result.map{ |k, v| format_color(k) +
                    P.send(colors[Hash   ]){ '=>'    }   +
                                         format_color(v) }.
               join(P.send(colors[Hash   ]){ ', '    }) +
                    P.send(colors[Hash   ]){ '}'     }

      else        ; if color = P.find_color(colors, result)
                    P.send(color){ display }
                    else
                    P.send(colors[Object      ]){ display }
                    end
    end
  end

  def get_error e, backtrace=e.backtrace
    return super if Color.disabled?
    [format_color(e, "#{e.class.to_s}: #{e.message}"),
     backtrace.map{ |b|
       path, rest = ::File.split(b)
       name, msgs = rest.split(':', 2)
       msg = msgs.sub(/(\d+):/){P.red{$1}+':'}.sub(/`.+?'/){P.green{$&}}

       "#{path+'/'}#{P.yellow{name}}:#{msg}"
     }]
  end



  module Imp
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

  Plugin.extend(Imp)
end
