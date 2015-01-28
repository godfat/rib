
require 'rib'

module Rib::Color
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    colors
    super
  end

  def format_result result
    return super if Color.disabled?
    config[:result_prompt] + format_color(result)
  end

  # --------------- Plugin API ---------------

  def colors
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
      Object     => :yellow }
  end

  def format_color result, display=result.inspect
    case result
      when String ; send(colors[String ]){ display }
      when Numeric; send(colors[Numeric]){ display }
      when Symbol ; send(colors[Symbol ]){ display }

      when Array  ; send(colors[Array  ]){ '['     }   +
                      result.map{ |e   | if e.object_id == result.object_id
                                           send(colors[Array]){'[...]'}
                                         else
                                           format_color(e); end }.
               join(send(colors[Array  ]){ ', '    })  +
                    send(colors[Array  ]){ ']'     }

      when Hash   ; send(colors[Hash   ]){ '{'     }   +
                      result.map{ |k, v| format_color(k) +
                    send(colors[Hash   ]){ '=>'    }   +
                                         if v.object_id == result.object_id
                                           send(colors[Hash]){'{...}'}
                                         else
                                           format_color(v); end }.
               join(send(colors[Hash   ]){ ', '    }) +
                    send(colors[Hash   ]){ '}'     }

      else        ; if color = find_color(colors, result)
                    send(color){ display }
                    else
                    send(colors[Object      ]){ display }
                    end
    end
  end

  # override StripBacktrace#get_error
  def get_error err
    return super if Color.disabled?
    message, backtrace = super
    [format_color(err, message), colorize_backtrace(backtrace)]
  end



  module_function
  def colorize_backtrace backtrace
    backtrace.map{ |b|
      path, msgs = b.split(':', 2)
      dir , file = ::File.split(path)
      msg = msgs.sub(/(\d+):/){red{$1}+':'}.sub(/`.+?'/){green{$&}}

      "#{dir+'/'}#{yellow{file}}:#{msg}"
    }
  end

  def find_color colors, value
    (colors.sort{ |(k1, _), (k2, _)|
      # Class <=> Class
      if    k1 < k2 then -1
      elsif k1 > k2 then  1
      else                0
      end}.find{ |(klass, _)| value.kind_of?(klass) } || []).last
  end

  def color rgb
    "\e[#{rgb}m" + if block_given? then "#{yield}#{reset}" else '' end
  end

  def   black &block; color(30, &block); end
  def     red &block; color(31, &block); end
  def   green &block; color(32, &block); end
  def  yellow &block; color(33, &block); end
  def    blue &block; color(34, &block); end
  def magenta &block; color(35, &block); end
  def    cyan &block; color(36, &block); end
  def   white &block; color(37, &block); end
  def   reset &block; color( 0, &block); end
end

begin
  require 'win32console' if defined?(Gem) && Gem.win_platform?
rescue LoadError => e
  Rib.warn("Error: #{e}"                                                  ,
           "Please install win32console to use color plugin on Windows:\n",
           "    gem install win32console\n"                               ,
           "Or add win32console to Gemfile if that's the case"            )
  Rib::Color.disable
end
